class Church < ActiveRecord::Base
	has_many :users
	validates :church_name, uniqueness: true
end
