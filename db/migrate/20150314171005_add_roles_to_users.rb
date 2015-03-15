class AddRolesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :church_admin, :boolean, default: false
    add_column :users, :church_leader, :boolean, default: false
  end
end
