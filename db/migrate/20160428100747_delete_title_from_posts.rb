class DeleteTitleFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :title
  end
end
