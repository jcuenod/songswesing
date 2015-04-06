class ChangeChurchIdNullable < ActiveRecord::Migration
  def change
    User.where(church_id: nil).update_all(church_id: 1)
    change_column_null(:users, :church_id, false)
  end
end
