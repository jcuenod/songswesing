class SongTag < ActiveRecord::Base
  belongs_to :song
  belongs_to :tag
  belongs_to :church
end
