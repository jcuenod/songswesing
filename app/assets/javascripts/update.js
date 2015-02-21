var update_original_var;

$(document).ready(function() {
	$("td").on("focus", function() {
		update_original_var = $(this).html();
	})
	.on("blur", function () {
		if (update_original_var == $(this).html())
			return;
		
		var dataToSend;
		dataToSend = {key: $(this).attr("name"), value: $(this).text().trim()};

		var toupdate = this;
		$.ajax({
            type: 'PUT',
            url:  '/songs/'+$(this).parent("tr").attr("name"),
            data: dataToSend,
            dataType: "JSON",
            success: function(data) {
                if (data.result)
                {
                	var trueColor = $(toupdate).css("backgroundColor");
					$(toupdate).animate({ backgroundColor: "#cce2ff" }, {
				        duration: 100, 
				        complete: function() {
				            // reset
				            $(toupdate).delay(10).animate(
				            	{ backgroundColor: trueColor }, { duration: 900 }
				            );
				        }
				    });
                }
            }
        });
	});
	$("[contenteditable=true]").bind("paste", function(e) {
	    var that = this
	    setTimeout(function(){$(that).html($(that).text())}, 0);
	});
});