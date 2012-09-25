class AddProfilePageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_page, :string
    add_index :users, :profile_page, :unique => true
  end
end
