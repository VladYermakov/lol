#! ruby
require "docopt"
require "active_support/inflector"

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
  def camelscope
  	self.split('_').inject("") {|x, y| x + y.capitalize}
  end
end

def time
  Time.now.to_s.split(/[-+: ]/)[0..-2].join
end

doc = <<DOCOPT

Usage:
  sinatra server|s [-o|--host <opt_o>] [-p|--port <opt_p>]
  sinatra generate|g COMMAND NAME [OPTS...]

Options:
  -h --help   Show this message
  -o --host   Hostname
  -p --port   Port

DOCOPT

model =<<MODEL
class %s < ActiveRecord::Base
end
MODEL

migration =<<MIGRATION
class %s < ActiveRecord::Migration
  def change
  end
end
MIGRATION

begin
	arguments = Docopt::docopt(doc)
rescue Docopt::Exit => e
	puts e.message
	exit
end

if arguments["s"] || arguments["server"]
  s = ""

  s += " -o " + arguments["<opt_o>"] unless arguments["<opt_o>"].nil?
  s += " -p " + arguments["<opt_p>"] unless arguments["<opt_p>"].nil?

  system "ruby main.rb" + s
else
  name = arguments["NAME"]

  case arguments["COMMAND"]
  when "model"
    File.open("models/#{name}.rb", "w").puts model % name.camelscope

    puts "create models/#{name}.rb"

    migration_name = "#{time}_create_table_#{name}s"

    file = File.open("db/migrate/#{migration_name}.rb", "w")
    file.puts "class CreateTable#{name.camelscope}s < ActiveRecord::Migration"
    file.puts "  def change"
    file.puts "    create_table :#{name}s do |#{name}|"
    arguments["OPTS"].each do |q|
      x, y = q.split(":")
      file.printf "      #{name}.#{y}\t\t"
      if x != ""
        file.puts ":#{x}"
      else
        file.puts
      end
    end
    file.puts "    end"
    file.puts "  end"
    file.puts "end"

    puts "create db/migrate/#{migration_name}.rb"

  when "migration"
    migration_name = "#{time}_#{name}"
    File.open("db/migrate/#{migration_name}.rb", "w").puts migration % name.camelscope

    puts "create db/migrate/#{migration_name}.rb"

  end

end
