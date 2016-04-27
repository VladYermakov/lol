#\ -o yermakov.com -p 8080
require "sinatra"
require "sinatra/cookies"
require "sinatra/activerecord"
require "./environment.rb"
require "./application_helper.rb"

Dir.glob("./models/*.rb").each { |file| require file}

include ApplicationHelper

before '/login/?' do 
	redirect to '/' unless current_user.nil?
end

before '/signin/?' do 
	redirect to '/' unless current_user.nil?
end

before do
	@user ||= current_user
end

get '/' do
	unless @user.nil?
		@posts = Post.where(user_id: @user.id)
	end
	erb :index
end

get '/login/?' do
	erb :login
end

post '/login/?' do
	@email = params[:email]
	@pass = params[:pass]
	@user = User.find_by_email(@email)
	return redirect to('/login') if @user.nil?
	@db_pass = @user.password
	if @pass == @db_pass
		cookies[:current_user] = @email
		redirect to('/')
	else
		redirect to("/login")
	end
end

get '/signin/?' do
	erb :signin
end

post '/signin/?' do
	@name = params[:name]
	@email = params[:email]
	@pass = params[:pass]
	@rep_pass = params[:rep_pass]
	@age = params[:age]

	redirect to '/signin' if @pass != @rep_pass

	User.create(name: @name, email: @email, password: @pass, age: @age)

	redirect to '/' 
end

get '/logout/?' do

	cookies.delete(:current_user)
	redirect to '/'

end