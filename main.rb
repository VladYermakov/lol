#\ -o yermakov.com -p 8080
require "sinatra"
require "sinatra/cookies"
require "sinatra/activerecord"
require "action_pack"
require "action_controller"
require "sinatra/flash"
require "faker"

Dir.glob("./app/{models,helpers}/*.rb").each { |file| require file }
Dir.glob("./config/*.rb").each { |file| require file }

set :views, settings.root + '/app/views'
set :public_folder, settings.root + '/app'

include ApplicationHelper
include SessionsHelper
