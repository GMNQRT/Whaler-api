class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :role, :string
    add_column :users, :skype, :string
    add_column :users, :linkedin, :string
    add_column :users, :twitter, :string
    add_column :users, :website, :string
    add_column :users, :bio, :text
  end
end
