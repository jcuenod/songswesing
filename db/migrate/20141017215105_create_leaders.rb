class CreateLeaders < ActiveRecord::Migration
  def change
    create_table :leaders do |t|
      t.string :leader_name

      t.timestamps
    end
  end
end
