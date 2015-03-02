class Song < ActiveRecord::Base
  has_many	:akas, dependent: :delete_all, :inverse_of => :song
  accepts_nested_attributes_for :akas, :reject_if => :all_blank, :allow_destroy => true
  validates_presence_of :akas

  def self.autocomplete(q)
    q = q.gsub(/(?=\S)(\W)/,"").squeeze(" ").downcase
    #where("song_name LIKE ?", q).order(:song_name).limit(5)
    four = Aka.where("search_text LIKE ?", "%#{q}%").distinct(:song_id).order(:display_text)
    three = Aka.where("search_text LIKE ?", "% #{q}%").distinct(:song_id).order(:display_text)
    two = Aka.where("search_text LIKE ?", "% #{q}% ").distinct(:song_id).order(:display_text)
    one = Aka.where("search_text LIKE ?", "#{q}%").distinct(:song_id).order(:display_text)
    (one + two + three + four).uniq.first(10)
  end

  def self.autocomplete_data(q)
    Song.autocomplete(q).map { |x| {"tag_id" => x.song_id, "label" => x.display_text} }
  end
end
