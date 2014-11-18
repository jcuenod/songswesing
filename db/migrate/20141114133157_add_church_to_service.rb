class AddChurchToService < ActiveRecord::Migration
  def change
    add_reference :services, :church, index: true
  end
end
