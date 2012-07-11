class AddUrlAndLocationAndAboutMeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :url, :string
    add_column :users, :location, :string
    add_column :users, :about_me, :text
  end
end
