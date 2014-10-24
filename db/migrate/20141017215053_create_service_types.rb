class CreateServiceTypes < ActiveRecord::Migration
  def change
    create_table :service_types do |t|
      t.string :service_type
      t.integer :weight

      t.timestamps
    end
  end
end
