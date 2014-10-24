class Song < ActiveRecord::Base
  has_many	:akas

  def self.autocomplete(q)
    #where("song_name LIKE ?", q).order(:song_name).limit(5)
    four = Aka.where("search_text LIKE ?", "%#{q}%").distinct(:song_id).order(:display_text)
    three = Aka.where("search_text LIKE ?", "% #{q}%").distinct(:song_id).order(:display_text)
    two = Aka.where("search_text LIKE ?", "% #{q}% ").distinct(:song_id).order(:display_text)
    one = Aka.where("search_text LIKE ?", "#{q}%").distinct(:song_id).order(:display_text)
    (one + two + three + four).uniq.first(10)
  end
  
  def self.autocomplete_data(q)
    Song.autocomplete(q).map { |x| {"tag_id" => x.id, "label" => x.display_text} }
  end
end
