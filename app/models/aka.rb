class Aka < ActiveRecord::Base
  belongs_to :song
  before_save :update_search_text

  private
  	def update_search_text
  	  self.search_text = self.display_text.gsub(/(?=\S)(\W)/,"").squeeze(" ").downcase if display_text_changed?
  	end
end
