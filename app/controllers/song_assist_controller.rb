class SongAssistController < ApplicationController
  def show
  	require 'open-uri'
  	@doc = Nokogiri::HTML(open("https://us.songselect.com/songs/" + params[:song][:ccli_number]))

	title = @doc.css(".media h2")[0].text
	authors = @doc.css(".details .authors")[0].text().squish
	copyright = @doc.css(".details .copyright li")[0].text().squish

	search_terms = []
	@doc.css("h3").each do |h3|
		next if h3.text() != "AKA"

		h3.next_element.search("li").each do |li|
			search_terms << li.text
		end
	end
	search_terms << title

	new_terms = []
	search_terms.each do |st|
		append = true
		new_terms.each_with_index do |nt, index|
			if nt.include? st
				append = false
				next
			elsif st.include? nt
				new_terms[index] = st
				append = false
				next
			end
		end
		new_terms << st if append
		Rails.logger.info new_terms.inspect
	end

	render json: {
		"title" => title,
		"authors" => authors,
		"copyright" => copyright,
		"search_terms" => new_terms
	}
  end
end
