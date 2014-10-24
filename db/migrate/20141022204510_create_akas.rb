class CreateAkas < ActiveRecord::Migration
  def change
    create_table :akas do |t|
      t.references :song, index: true
      t.string :search_text
      t.string :display_text

      t.timestamps
    end
  end
end
