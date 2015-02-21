var update_original_var;

$(document).ready(function() {
	$("td").on("focus", function() {
		update_original_var = $(this).html();
	})
	.on("blur", function () {
		if (update_original_var == $(this).html())
			return;
		
		var dataToSend;
		dataToSend = {key: $(this).attr("name"), value: $(this).html()};

		$.ajax({
            type: 'PUT',
            url:  '/songs/'+$(this).parent("tr").attr("name"),
            data: dataToSend,
            dataType: "JSON",
            success: function(data) {
                if (data.result)
                {
					/*Update the html of the div flash_notice with the new one*/
					$("#alert-success").html("Field updated");
					/*Show the flash_notice div*/
					$("#alert-sucess").show(300).hide(500);
                }
            }
        });
	});
});