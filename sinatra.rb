#! ruby
require "docopt"
require "active_support/inflector"

doc = <<DOCOPT

Usage:
  sinatra server|s [-o|--host <opt_o>] [-p|--port <opt_p>]
  sinatra generate|g <type> <name> [<opts>]

Options:
  -h --help   Show this message
  -o --host   Hostname
  -p --port   Port

DOCOPT

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
  case arguments["<type>"]
  when "model"

  when "migration"
    name = arguments["<name>"]
    system "rake db:create_migration NAME=#{name}"
  end

end
