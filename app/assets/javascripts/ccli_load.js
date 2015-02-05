function ccli_loader (ccli_number)
{
	console.log("CCLI:" + ccli_number);

	var jqxhr = $.get("http://us.songselect.com/songs/" + ccli_number)
	  .done(function(data) {
	    console.log(data);
	    var html = $.parseHTML(data);
	    $("#song_song_name").val(   $(html).find(".media h2").html() );
	    $("#song_writers").val(     $(html).find(".details .authors").text().replace(/\n/g, ' ').replace(/\s{2,}/g, ' ').trim() );
	    $("#song_license").val(     $(html).find(".details .copyright li").first().text().trim() );

	    $(html).find("h3").each( function () {
	    	if ($(this).text() != "AKA")
	    		return;

	    	$(this).next().find("li").each(function () {
	    		$(".add_fields").click()
	    		$(".nested-fields").last().find("input[id$='display_text']").val( $(this).text() );
	    		$(".nested-fields").last().find("input[id$='search_text']").val(
    				$(this).text()
    					.replace(/(?=\S)(\W)/, "")	//remove non-word stuff (like apostrophes) - from the aka search side
    					.replace(/\s{2,}/g, ' ')	//remove duplicated spaces
    					.trim()						//remove whitespace around the edges
    					.toLowerCase()				//figure it out bro
	    		);

	    	})
	    })
	  })
	  .fail(function(e) {
	    console.log( "Something appears to have gone wrong:" );
	    console.log( "(honestly, this is an XSS disaster so you better know what you're doing)" );
	    console.log( "Here's the error though:" );
	    console.log( e );
	  })
	  /*.always(function() {
	    console.log( "finished" );
	  })*/;
}