require "uri/mailto"

class User < ActiveRecord::Base

	validates :name,  presence: true, format: {with: /\A[a-zA-Z0-9_]{2,50}\z/i},
										 							  uniqueness: {case_sensetive: false}
	validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP},
																		uniqueness: {case_sensetive: false}
  validates :password, length: {minimum: 6}

	before_save do
		self.name = self.name.downcase
		self.email = self.email.downcase
	end

	before_create :create_remember_token

	before_create { generate_token(:auth_token) }

	has_secure_password

	has_many :posts, dependent: :destroy

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end

	private
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end
