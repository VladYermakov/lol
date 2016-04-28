#\ -w -o yermakov.com -p 8080
map '/' do
  require './main.rb'
  run Sinatra::Application
end
