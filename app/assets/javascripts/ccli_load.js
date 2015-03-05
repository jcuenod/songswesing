function ccli_loader ()
{
	$(".ccli_populate").removeClass("glyphicon-cloud-download").addClass("glyphicon-refresh glyphicon-spin")
	var jqxhr = $.ajax({
		'url': "/songassist",
		"type": 'POST',
		"data": $("#song_ccli_number").serialize(),
		"success": function(data) {
		  	$(".ccli_populate").removeClass("glyphicon-refresh glyphicon-spin").addClass("glyphicon-cloud-download")

		    $("#song_song_name").val(data.title);
		    $("#song_writers").val(data.authors);
		    $("#song_license").val(data.copyright);

		    for (st in data.search_terms) {
		    	$(".add_fields").click()
		    	$(".nested-fields").last().find("input[id$='display_text']").val(data.search_terms[st]);
		    }
		},
		"error": function(a,b,c) {
			alert ("Sorry, either the server was too slow or your song can't be found, try looking up this url:\n" + "https://us.songselect.com/songs/" + $("#song_ccli_number").val());
			$.featherlight.close();
			console.log("Here's the real error:");
			console.log(a);
			console.log(b);
			console.log(c);
		}
	});
}