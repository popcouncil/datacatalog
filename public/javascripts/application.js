$(document).ready(function(){
  $("ul.star-ratingActive li.oneStar").hover(function(){
    $(this).parent().removeClass("ratedTwoStars").removeClass("ratedThreeStars").removeClass("ratedFourStars").removeClass("ratedFiveStars").addClass("ratedOneStar");
  });
  $("ul.star-ratingActive li.twoStars").hover(function(){
    $(this).parent().removeClass("ratedOneStar").removeClass("ratedThreeStars").removeClass("ratedFourStars").removeClass("ratedFiveStars").addClass("ratedTwoStars");
  });
  $("ul.star-ratingActive li.threeStars").hover(function(){
    $(this).parent().removeClass("ratedOneStar").removeClass("ratedTwoStars").removeClass("ratedFourStars").removeClass("ratedFiveStars").addClass("ratedThreeStars");
  });
  $("ul.star-ratingActive li.fourStars").hover(function(){
    $(this).parent().removeClass("ratedOneStar").removeClass("ratedTwoStars").removeClass("ratedThreeStars").removeClass("ratedFiveStars").addClass("ratedFourStars");
  });
  $("ul.star-ratingActive li.fiveStars").hover(function(){
    $(this).parent().removeClass("ratedOneStar").removeClass("ratedTwoStars").removeClass("ratedThreeStars").removeClass("ratedFourStars").addClass("ratedFiveStars");
  });
  $("ul.star-ratingActive").hover(function(){
  }, function(){
    $(this).removeClass("ratedOneStar").removeClass("ratedTwoStars").removeClass("ratedThreeStars").removeClass("ratedFourStars").removeClass("ratedFiveStars");
  });

  $("div#favoriteData_dropdown").hide();

  $("div#favoriteData a.buttonLink").toggle(
    function(){
       $(this).addClass("active");
       $("div#favoriteData_dropdown").slideDown("slow");
    },
    function(){
         $(this).removeClass("active");
         $("div#favoriteData_dropdown").slideUp("slow");
      }
  );

  $("li#moveBtn a.buttonLink").toggle(
    function(){
       $(this).addClass("active");
       $("div#favoriteData_dropdown").slideDown("slow");
    },
    function(){
         $(this).removeClass("active");
         $("div#favoriteData_dropdown").slideUp("slow");
      }
  );

  $("ul#additionalFields_details").hide();

  $("div#additionalFields h3 a").toggle(
    function(){
       $("ul#additionalFields_details").slideDown("slow");
    },
    function(){
         $("ul#additionalFields_details").slideUp("slow");
      }

  );

  $("form.generateAPI").hide();

  $("div#additionalKeys a.addLink").toggle(
    function(){
       $("form.generateAPI").slideDown("slow");
    },
    function(){
         $("form.generateAPI").slideUp("slow");
      }

  );

  $("div#addTag").hide();

  $("a#addTagLink").toggle(
    function(){
       $("div#addTag").slideDown("slow");
    },
    function(){
         $("div#addTag").slideUp("slow");
      }
  );

  $("div#addFolder").hide();

  $("a#addFolderLink").toggle(
    function(){
       $("div#addFolder").slideDown("slow");
    },
    function(){
         $("div#addFolder").slideUp("slow");
      }
  );

  $("ul.tabs").tabs("div.tab_panes > div.tab_pane", {
    current: 'active'
  });

  $("ul.toggable-fields input[type=radio]").change(function() {
    var radio = $(this),
        ul = radio.parents("ul");
    ul.find("li.toggable input").val("");
    ul.find("li.toggable").hide();
    ul.find("li." + radio.val()).show();
    ul.find("li.format").show();
  })

  $(".toggable-fields .toggable").hide()

  $("ul.toggable-fields input[type=radio]").each(function() {
    if ($(this).attr("checked")) {
      $(".toggable-fields ." + $(this).val()).show()
      $(".toggable-fields .format").show()
    }
  })

  // Handle "Add Another" links for nested forms
  $(".add_another a").click(function() {
    var addAnother = $(this).parents(".add_another"),
        container = addAnother.parent(),
        target = container.find("li:first-child"),
        cloned = target.clone(),
        element = cloned.find("select, input");

    var amount = container.find("li:not(.add_another)").size();

    cloned.append(removeLink(container));

    element.each(function() {
      var elem = $(this),
          name = elem.attr("name").replace(/\[\d+\]/, '[' + amount + ']'),
          id   = elem.attr("id").replace(/_\d+_/, '_' + amount + '_');

      elem.val("");
      elem.parent().find("label").attr("for", id);
      elem.attr("name", name);
      elem.attr("id", id);
    });

    addAnother.before(cloned.show())

    container.trigger("fieldAdded", [cloned]);
  });

  var removeLink = function(container) {
    return $('<a href="javascript:" class="remove_link">Remove</a>').click(function() {
      var element = $(this).parent();
      container.trigger("fieldRemoved", [element]);
      element.remove();
    });
  }

  // Handle Add Location for Data Records

  $("#location_fields").bind("fieldAdded", function(_, field) {
    // Remove the "Global" and first separator from "extra" locations
    field.find("option:first-child").remove();
    field.find("option:first-child").remove();
    field.find("label").css({ visibility: "hidden" });
  });

  $("#location_fields").each(function() {
    $(this).find("li:not(:first-child) label").css({ visibility: "hidden" });
    $(this).find("li:not(:first-child):not(.add_another)").each(function() {
      $(this).append(removeLink($(this)));
    });
  });

  var toggleLocationsAddAnother = function() {
    var container = $(this).parents("#location_fields"),
        addAnother = container.find(".add_another");

    if ($(this).find("option:selected").text() == "Global") {
      addAnother.hide();
      container.find("li:not(.add_another):not(:first-child)").remove();
    } else {
      addAnother.show();
    }
  }

  $("#location_fields select").each(toggleLocationsAddAnother);
  $("#location_fields select").change(toggleLocationsAddAnother);

  // Handle Add Author for Data Records

  $("#authors").bind("fieldAdded", function(_, li) {
    li.find("input[id*=affiliation]").val($("#data_record_lead_organization_name").val());

    // at most 3 authors (plus the hidden one)
    if ($(this).find("li:not(.add_another)").size() >= 4)
      $(this).find(".add_another").hide()
    else
      $(this).find(".add_another").show()
  });

  $("#authors").bind("fieldRemoved", function() {
    $(this).find(".add_another").show()
  });

  $("#authors li:first-child").hide();
});
