module ApplicationHelper
	def current_user
		@current_user ||= cookies[:current_user]
		@user = User.find_by_email(@current_user)
		@name = @user.name unless @user.nil?
		@current_user
	end
end