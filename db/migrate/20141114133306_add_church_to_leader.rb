class AddChurchToLeader < ActiveRecord::Migration
  def change
    add_reference :leaders, :church, index: true
  end
end
