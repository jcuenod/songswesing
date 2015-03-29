class CreateSongTags < ActiveRecord::Migration
  def change
    create_table :song_tags do |t|
      t.references :song, index: true
      t.references :tag, index: true
      t.references :church, index: true

      t.timestamps
    end
  end
end
