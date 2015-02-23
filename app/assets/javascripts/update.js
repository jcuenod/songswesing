var update_original_var;

$(document).ready(function() {
	$("td[contenteditable=true]").on("focus", function() {
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
            url:  '/' + $("table.masteredit").attr("id") + '/'+$(this).parent("tr").attr("id"),
            data: dataToSend,
            dataType: "JSON",
            success: function(data) {
            	console.log (data);
                if (data.result)
                {
					markUpdate($(toupdate))
				    $(toupdate).siblings("td").each(function() {
				    	if ($(this).text() != data.object[$(this).attr("name")] && typeof(data.object[$(this).attr("name")]) != "undefined")
				    	{
				    		$(this).text( data.object[$(this).attr("name")] );
				    		markUpdate($(this))
				    	}

				    })
                }
                else {
                	$(toupdate).text(update_original_var);
                	console.log("You should check rails logs because something went wrong with that update");
                	var trueColor = $(toupdate).css("backgroundColor");
					$(toupdate).animate({ backgroundColor: "#ffe2cc" }, {
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

function markUpdate(el)
{
	var trueColor = $(el).css("backgroundColor");
	$(el).animate({ backgroundColor: "#cce2ff" }, {
        duration: 100,
        complete: function() {
            // reset
            $(el).delay(10).animate(
            	{ backgroundColor: trueColor }, { duration: 900 }
            );
        }
    });
}