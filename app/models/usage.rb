class Usage < ActiveRecord::Base
  belongs_to :song
  belongs_to :service
end
