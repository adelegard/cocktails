class BannableUsers < ActiveRecord::Migration
  def up
    add_column :users, :banned, :boolean, :default => false
  end

  def down
    remove_column :users, :banned
  end
end
