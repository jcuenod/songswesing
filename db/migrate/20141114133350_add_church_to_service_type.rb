class AddChurchToServiceType < ActiveRecord::Migration
  def change
    add_reference :service_types, :church, index: true
  end
end
