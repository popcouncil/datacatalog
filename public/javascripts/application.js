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

  // Toggle upload/external url for documents
  $(".toggable-fields input:radio").live("change", function() {
    var radio = $(this),
        container = radio.parents(".toggable-fields");
    container.find(".toggable input").val("");
    container.find(".toggable").hide();
    container.find("." + radio.val()).show();
  })

  $(".toggable-fields .toggable").hide()

  $(".toggable-fields input:radio").each(function() {
    if ($(this).attr("checked")) {
      $(this).parents(".toggable-fields").find("." + $(this).val()).show()
    }
  })

  // Handle "Add Another" links for nested forms
  $(".add_another a").click(function() {
    var addAnother = $(this).parents(".add_another"),
        container = addAnother.parent(),
        target = container.find("li:first-child"),
        cloned = target.clone(),
        elements = cloned.find("select, input");

    var amount = container.find("li:not(.add_another)").size();

    cloned.append(removeLink(container));

    elements.each(function() {
      var elem  = $(this),
          label = elem.parent().find("label[for=" + elem.attr("id") + "]"),
          name  = elem.attr("name").replace(/\[\d+\]/, '[' + amount + ']'),
          id    = elem.attr("id").replace(/_\d+_/, '_' + amount + '_');

      label.attr("for", id);

      if (elem.is(":text")) {
        elem.val("");
      } else if (elem.is(":checkbox") || elem.is(":radio")) {
        elem.attr("checked", false)
      }

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

  // Handle Add Document for Data Records
  $("#documents_fields").bind("fieldAdded", function(_, li) {
    li.find(".toggable").hide();
  });
});
