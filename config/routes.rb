before '/login/?' do
	redirect to '/' unless current_user.nil?
end

before '/signin/?' do
	redirect to '/' unless current_user.nil?
end

before do
	@user ||= current_user
end

get '/?' do
	unless @user.nil?
		@posts = Post.where(user_id: @user.id)
	end
	erb :index
end

#==sessions==

get '/login/?' do
	erb :'sessions/new'
end

post '/login/?' do
	user = User.find_by_email(params[:email].downcase)
	if user && user.authenticate(params[:pass])
		sign_in user
		redirect to('/')
	else
		flash.now[:error] = "Invalid email/password combination"
		redirect to("/login")
	end
end

get '/signup/?' do
	erb :'sessions/create'
end

post '/signup/?' do
	@name = params[:name]
	@email = params[:email]
	@pass = params[:pass]
	@rep_pass = params[:rep_pass]
	@age = params[:age]

	redirect to '/signup' if @pass != @rep_pass

	User.create(name: @name, email: @email, password: @pass, age: @age)

	redirect to '/'
end

get '/logout/?' do

	current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
  cookies.delete(:remember_token)
  self.current_user = nil
	redirect to '/'

end

get '/users/:id/?' do
	@user = User.find(params[:id])
	unless @user.nil?
		@posts = Post.where(user_id: @user.id)
		erb :'users/show'
	else
		erb :'404'
	end
end

get '/users/?' do
  @users = User.all
  erb :'users/index'
end
