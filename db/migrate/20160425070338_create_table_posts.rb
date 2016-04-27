class CreateTablePosts < ActiveRecord::Migration
  def change
  	create_table :posts do |post|
  		post.string		:title
  		post.text		:content
  		post.integer	:user_id

  		post.timestamps null: false
  	end
  end
end
