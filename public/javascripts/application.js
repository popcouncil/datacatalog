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

    cloned.find(".remove_checkbox, .remove_link").remove();
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
    
    // hide elements flagged to do so
    cloned.find(".hide-on-clone").hide();
    
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

  $(".remove_checkbox").each(function() {
    var checkboxContainer = $(this);
    checkboxContainer.hide();

    var link = $('<a href="javascript:" class="remove_link">Remove</a>');
    link.click(function() {
      var element = checkboxContainer.parents("li"),
          container = element.parent();
      container.trigger("fieldRemoved", [element]);

      checkboxContainer.find(":checkbox").attr("checked", true)
      element.hide();
    });

    checkboxContainer.before(link);
  });

  // Handle Add Location for Data Records
  $("#location_fields li:first-child").each(function() {
    $(this).find(".remove_link, .remove_checkbox").remove();
  });

  var removeGlobalOption = function(container) {
    container.find("select.geo-location > option[value=1]").remove(); // Global
    var $select = container.find('select.geo-location');
    $select.val('0');
    $('select.geo-location').each(function(){
      if($(this).val() == '0'){ return; }
      $select.find('option[value=' + $(this).val() + ']').remove();
    });
    //container.find("select.geo-location > option:first-child").remove(); // ----------
    container.find("label").css({ visibility: "hidden" });
  }

  $("#location_fields").bind("fieldAdded", function(_, field) {
    removeGlobalOption(field)
    if($('.geo-location option:selected[value=0]').length > 0){ $('#location_fields .add_another').hide(); } else { $('#location_fields .add_another').show(); }
  });

  $("#location_fields").each(function() {
    $(this).find("li:not(:first-child) label").css({ visibility: "hidden" });
    $(this).find("li:not(:first-child):not(.add_another)").each(function() {
      removeGlobalOption($(this))
    });
  });

  var toggleLocationsAddAnother = function(self) {
    var container = self.parents("#location_fields"),
        addAnother = container.find(".add_another");

    if (self.find("option:selected").text() == "Global") {
      addAnother.hide();
      container.find("li:not(.add_another):not(:first-child)").remove();
    } else {
      addAnother.show();
    }
  };
  
  var toggleDisaggregationLevelSelector = function(self) {
    var disabled_options = ["Select Geographical Coverage", "Global","Africa","Asia","Europe","North America","Oceania","South America"];
    var selected_choice = self.find("option:selected").text();
    var disaggregation_widget = self.parent().find(".disaggregation-level");
    // show if selected option is not global or world region (continent)
    if ( jQuery.inArray(selected_choice, disabled_options) == -1 ) {
      disaggregation_widget.find(".tip").text("Select lowest level of disaggregation for " + selected_choice);
      disaggregation_widget.show();
    } else {
      disaggregation_widget.hide();
    }
  };
  
  $("#location_fields select.geo-location").each(function() {
    toggleLocationsAddAnother($(this));
    toggleDisaggregationLevelSelector($(this));
  });
  
  $("#location_fields select.geo-location").live('change', function(){
    toggleLocationsAddAnother($(this));
    toggleDisaggregationLevelSelector($(this));
  });

  // Handle Add Author for Data Records

  $("#authors").bind("fieldAdded", function(_, li) {
    li.find("input[id*=affiliation]").val($("#data_record_lead_organization_name").val());
  });

  $("#authors").bind("fieldRemoved", function() {
    $(this).find(".add_another").show()
  });

  $("#authors li:first-child").hide();

  // Handle Add Document for Data Records
  $("#documents_fields").bind("fieldAdded", function(_, li) {
    li.find(".toggable").hide();
    li.find(".current_file").remove();
  });

  // Only show add_another links if all elements in the current field are filled
  $("#authors, #documents_fields").bind("fieldAdded", function() {
    $(this).find(".add_another").hide();
    $('#documents_fields li:hidden:not(.add_another)').remove();
  });

  var showOrHideAddAuthorLink = function() {
    var hasEmpty = $("#authors .required").filter(function() {
      return $(this).val() == "";
    }).size() > 1; // the hidden one

    if (hasEmpty || ($("#authors").find("li:not(.add_another)").size() >= 4)) {
      $("#authors .add_another").hide()
    } else {
      $("#authors .add_another").show()
    }
  }

  $("#authors .required").live("keyup", showOrHideAddAuthorLink);

  var showOrHideAddDocumentLink = function() {
    var hasEmpty = $("#documents_fields .toggable-fields").filter(function() {
      return ($(this).find(".upload .required").val() == "") && ($(this).find(".external .required").val() == "") && ($(this).find(".current_file").size() == 0);
    }).size() > 0;

    if (hasEmpty) {
      $("#documents_fields .add_another").hide()
    } else {
      $("#documents_fields .add_another").show()
    }
  }

  $("#documents_fields .upload .required").live("change", showOrHideAddDocumentLink);
  $("#documents_fields .external .required").live("keyup", showOrHideAddDocumentLink);
  $("#documents_fields :radio").live("change", showOrHideAddDocumentLink);

  showOrHideAddDocumentLink();
  showOrHideAddAuthorLink();

  $('#user_alert_email,#user_alert_sms').click(function(){
    if($('#tags__tag_id').val() == 'All' && $('#locations__location_id').val() == '1'){
    return false;
    }
    return true;
  });

  function hide_alert_links(){
    if($('.alert_tags').length < 2){ $('#del-alert-topic').hide(); } else {  $('#del-alert-topic').show(); }
    if($('.alert_locations').length < 2){ $('#del-alert-location').hide(); } else { $('#del-alert-location').show(); }
    if($('.alert_tags option:selected[value=All]').length == 1 || $('.alert_tags option:selected[value=0]').length >= 1 || $('.alert_tags').length > 16){ $('#add-alert-topic').hide(); } else {$('#add-alert-topic').show();}
    if($('.alert_locations[value=0]').length == 1){ $('#add-alert-location').hide(); } else {$('#add-alert-location').show();}
    if($('.alert_tags[value=Select Topics]').length == 1 && $('.alert_locations[value=Select Coverage]').length == 1){
      $('#user_alert_email').attr('checked', false).attr('disabled', true);
      $('#user_alert_sms').attr('checked', false).attr('disabled', true);
      $('#user_alert_sms_number').attr('disabled', true);
    } else {
      $('#user_alert_email').attr('disabled', false);
      $('#user_alert_sms').attr('disabled', false);
      $('#user_alert_sms_number').attr('disabled', false);
    }
  }
  hide_alert_links();

  $('.alert_tags, .alert_locations').live('change', function(){
    hide_alert_links();
  });

  $('#del-alert-topic, #del-alert-location').live('click', function(){
    hide_alert_links();
  });

  $('#add-alert-topic').live('click', function(){
    hide_alert_links();
    var $item = $('.alert_tags:last');
    $('.alert_tags:not(:last)').each(function(){
      $item.find('option[value=' + $(this).val() + ']').remove();
    });
  });

  $('#add-alert-location').live('click', function(){
    hide_alert_links();
    var $item = $('.alert_locations:last');
    $('.alert_locations:not(:last)').each(function(){
      $item.find('option[value=' + $(this).val() + ']').remove();
    });
  });

  $('#remove-data-record-tag').live('click', function(){
    $(this).prev().remove();
    $(this).remove();
    return false;
  });

  function show_hide_add_tag(){
    if($('.data-record-tag option:selected[value=Select Tag]').length > 0 || $('.data-record-tag option:selected[value=Agriculture & Rural Development,Aid Effectiveness,Economic Policy and External Debt,Education,Energy & Mining,Environment,Financial sector,Health,Infrastructure,Labor & Social Protection,Poverty,Private Sector,Public Sector,Science & Technology,Social Development,Urban Development,Other]').length > 0 || $('.data-record-tag').length > 16){
      $('#add-data-record-tag').hide();
    } else {
      $('#add-data-record-tag').show();
    }
    if($('#user_alert_sms:checked').length < 1){
      $('#user_alert_sms_number').attr('disabled', true);
    } else {
      $('#user_alert_sms_number').attr('disabled', false);
    }
    var $item = $('.data-record-tag:last');
    $('.data-record-tag:not(:last)').each(function(){
      $item.find('option[value=' + $(this).val() + ']').remove();
    });
    if($('.geo-location option:selected[value=0]').length > 0){ $('#location_fields .add_another').hide(); } else { $('#location_fields .add_another').show(); }
  }

  $('.data-record-tag, #user_alert_sms').live('change', show_hide_add_tag);
  $('#add-data-record-tag').click(show_hide_add_tag);
  show_hide_add_tag();

  $('#documents_fields .remove_link').live('click', function(){
    if($('#documents_fields .remove_link:visible').length == 0) { $('#documents_fields .add_another').show(); }
  });
  
});
