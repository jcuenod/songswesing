class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :song_name
      t.string :license
      t.string :writers
      t.string :lyrics_url
      t.integer :sof_number
      t.string :sample_url

      t.timestamps
    end
  end
end
