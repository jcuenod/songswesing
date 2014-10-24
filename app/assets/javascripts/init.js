var myLightboxChart;
var myFeatherBox;
var tagOptions = new Array();

$( document ).ready(function() {
    $(document).on('ajax:success',function(data, status, xhr){
        switch(status.what)
        {
            case "created":
                switch (status.whatCreated)
                {
                    case "service":
                        $('.insertionForm').after(status.htmlOutput);
                        break;
                    case "leader":
                        $("#service_leader_id").append(status.htmlOutput);
                        break;
                    case "service_type":
                        $("#service_service_type_id").append(status.htmlOutput);
                        break;
                    case "song":
                        $("#songList").tagit('createTag', status.tag.id, status.tag.label);
                        break;
                }
                break;
        }
    }).on('ajax:error',function(xhr, status, error){
      console.log(error);
      alert("failed")
    });

    var elem = document.createElement('input');
    elem.setAttribute('type', 'date');
    if ( elem.type === 'text' ) {
        $('#service_date').datepicker({
            dateFormat: 'yy-mm-dd',
        });
    }

    $("#songList").tagit({
        tagSource: function(search, showChoices) {
		    $.ajax({
		      url: "/songs/list",
		      type: "POST",
		      data: search,
		      success: function(choices) {
		      	tagOptions = choices;
		        showChoices(choices);
		      },
		      error: function(e) {
		      	console.log("something's wrong with fetching sons");
		      	console.log(e);
		      }
		    });
		},
        allowSpaces: true,
        allowNewTags: false,
        onlyAvailableTags : true,
        removeConfirmation: true,
        /*afterTagAdded: function ()
        {
            $(".ui-autocomplete-input").autoGrow(8);
        },*/
        // autocomplete: {
        //     delay: 0,
            // source: function(request, response) {
	           //  var term = $.ui.autocomplete.escapeRegex(request.term);
	           //  var startsWithMatcher = new RegExp("^" + term, "i");
	           //  var startsWith = $.grep(source, function(value) {
	           //      return startsWithMatcher.test(value.label || value.value || value);
	           //  });
	           //  var containsMatcher = new RegExp(term, "i");
	           //  var contains = $.grep(source, function (value) {
	           //      return $.inArray(value, startsWith) < 0 &&
	           //          containsMatcher.test(value.label || value.value || value);
	           //  });

	           //  response(startsWith.concat(contains));
            // },
            // sortResults: false
        // },
        onSubmit: function() {
            //TODO: clear the stuff once it's submitted
        },
        fieldName: 'service[songs][]',
    });
});

function addnewAnchorClicked(thingToAdd)
{
    var jqxhr = $.ajax("/" + thingToAdd + "/new")
        .done(function(data) {
            myFeatherBox = $.featherlight(data, {
                afterOpen: function() {
                    $("form#frm_create").validate();
                    $("#frm_create input[type!=hidden]")[0].focus();
                }
            });
            $("#frm_create input[type=submit]").on("click", function(e){
                myFeatherBox.close();
            })
        })
        .fail(function(e) {
            console.log( "error creating addnew form" );
            console.dir(e);
        });
}
function songUsageAnchorClicked()
{
    var jqxhr = $.post( "/usages/data/10")
        .done(function(data) {
            myFeatherBox = $.featherlight("<div class='breakdown_header'>Usage Summary</div><div id='feather'>" + data + "</div>");
        })
        .fail(function(e) {
            console.log( "error" );
            console.dir(e);
        });
}
function songAnchorClicked(song_id)
{
    var jqxhr = $.post("/songs/data/" + song_id)
        .done(function(data) {
            try {myLightboxChart.destroy(); }catch(e){console.log("something's gone wrong with the chart stuff: ");console.log(e);}
            var mc = $("<canvas height=250>");
            var ctx = mc.get(0).getContext("2d");
            myLightboxChart = new Chart(ctx).Doughnut(data.chart_data, {
                animationSteps : 60
            });
            var tabledata = "";
            for (var key in data.song_details) {
                tabledata += "<tr><td>" + key + "</td><td>" + data.song_details[key] + "</td></tr>";
            }
            $.featherlight.close();
            $.featherlight("<div class='breakdown_header'>" + data.song_name + " (" + data.tally + ")</div>" +
                "<div id='feathersac' style='text-align:center; margin: 10px'></div>" + 
                "<div><table class='table table-condensed table-striped'>" +
                tabledata +
                "</table></div>");
            $("#feathersac").html($(mc));
        })
        .fail(function(e) {
            console.log( "error" );
            console.dir(e);
        });
}
function leaderAnchorClicked(el)
{
    /*var leader_name = $(el).html();
    var jqxhr = $.post( "/leaders/:id" )
        .done(function(data) {
            var arrlabel = new Array();
            var arrdata1 = new Array();
            var arrdata2 = new Array();
            for (d in data)
            {
                arrlabel.push(data[d].song_name);
                arrdata1.push(data[d].tally);
                arrdata2.push(data[d].total);
            }
            var completedata = {
                labels: arrlabel,
                datasets: [
                    {
                        label: "My First dataset",
                        fillColor: "rgba(220,220,220,0.5)",
                        strokeColor: "rgba(220,220,220,0.8)",
                        highlightFill: "rgba(220,220,220,0.75)",
                        highlightStroke: "rgba(220,220,220,1)",
                        data: arrdata2
                    },
                    {
                        label: "My Second dataset",
                        fillColor: "rgba(151,187,205,0.5)",
                        strokeColor: "rgba(151,187,205,0.8)",
                        highlightFill: "rgba(151,187,205,0.75)",
                        highlightStroke: "rgba(151,187,205,1)",
                        data: arrdata1
                    }
                ]
            };
            try {myLightboxChart.destroy(); }catch(e){console.log("something's gone wrong with the chart stuff: ");console.log(e);}
            var mc = $("<canvas width=600 height=400>");
            var ctx = mc.get(0).getContext("2d");
            myLightboxChart = new Chart(ctx).Bar(completedata);
            $.featherlight("<div class='breakdown_header'>" + leader_name + "</div><div id='feather'></div>");
            $("#feather").html($(mc));
            //$.featherlight("<div>" + data + "</div>");
        })
        .fail(function(e) {
            console.log( "error" );
            console.dir(e);
        });*/
}