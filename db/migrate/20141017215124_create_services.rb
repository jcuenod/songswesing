class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.date :date
      t.references :leader, index: true
      t.references :service_type, index: true

      t.timestamps
    end
  end
end
