class AddFieldsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :name, :string
    add_column :posts, :body, :text
  end
end
