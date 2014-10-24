class CreateUsages < ActiveRecord::Migration
  def change
    create_table :usages do |t|
      t.references :song, index: true
      t.references :service, index: true

      t.timestamps
    end
  end
end
