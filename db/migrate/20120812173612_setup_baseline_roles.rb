class SetupBaselineRoles < ActiveRecord::Migration
  def up
    add_index :roles, :name, :unique => true
    Role.create :name => "super_admin"
    Role.create :name => "admin"
    Role.create :name => "moderator"
    Role.create :name => "editor"
    Role.create :name => "basic"
  end

  def down
  end
end
