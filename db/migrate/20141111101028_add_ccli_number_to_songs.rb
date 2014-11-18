class AddCcliNumberToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :ccli_number, :string
  end
end
