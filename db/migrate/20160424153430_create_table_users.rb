class CreateTableUsers < ActiveRecord::Migration
  def change
  	create_table :users do |user|
  	  user.string  :name
  	  user.string  :email
  	  user.string  :password
  	  user.integer :age
  	end 
  	User.create(name: "Vlad",   email: "lol@gmail.com", password: "123123", age: 18)
  	User.create(name: "Marina", email: "marina@gm.com", password: "123123", age: 18)
  end
end
