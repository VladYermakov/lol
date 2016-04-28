ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "localhost",
  :port 	=> "3306",
  :username => "root",
  :password => "",
  :database => "rubydbs"
)

after do
	ActiveRecord::Base.connection.close
end