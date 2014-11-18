class AddChurchToUser < ActiveRecord::Migration
  def change
    add_reference :users, :church, index: true
  end
end
