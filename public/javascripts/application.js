
function show_hide_datarecord(){
  if($('select.geo-location option:selected[value=0]').length < 2){
    $('.geo-location-add:not(:last)').hide();
    $('.geo-location-add:last').show();
  } else {
    $('.geo-location-add').hide();
  }
  if($('select.geo-location').length > 2){
    $('.geo-location-del').show();
  } else {
    $('.geo-location-del').hide();
  }
  if($('.affiliation').length > 2){
    $('.affiliation-add:not(:last)').hide();
    $('.affiliation-add:last').show();
    $('.affiliation-remove').show();
  } else {
    $('.affiliation-add:not(:last)').hide();
    $('.affiliation-add:last').show();
    $('.affiliation-remove').hide();
  }
  if($('select.data-record-tag option:selected[value=Agriculture & Rural Development,Aid Effectiveness,Economic Policy and External Debt,Education,Energy & Mining,Environment,Financial sector,Health,Infrastructure,Labor & Social Protection,Poverty,Private Sector,Public Sector,Science & Technology,Social Development,Urban Development,Other]').length > 0){
    $('.add-tag').hide();
  } else {
    $('.add-tag:not(:last)').hide();
    $('.add-tag:last').show();
  }
  $('select.geo-location').each(function(){
    if(['1', '0', '65', '2', '156', '17', '152', '119'].indexOf($(this).val()) == -1){
      $(this).parent().next().show().children('select').customSelect();
    } else {
      $(this).parent().next().hide();
    }
  });
}

$(document).ready(function(){
  // star hovering
  // #favoriteData_dropdown and #favoriteData a.buttonLink toggling
  // #moveBtn a.buttonLink toggling
  // #additionalFields_details toggling
  // generate API and #additionalKeys toggling
  // #addTag toggling
  // #addFolder toggling

  $("ul.tabs").tabs("div.tab_panes > div.tab_pane", {
    current: 'active'
  }); // not sure if we're using this anymore

  // Handle "Add Another" links for nested forms # This is stupid

  // Handle Add Location for Data Records

  // Handle Add Author for Data Records

  // Handle Add Document for Data Records

  // Only show add_another links if all elements in the current field are filled

  // showorhideaddauthorlink

  // show or hide add document link

  show_hide_datarecord();

  $('.link-add,.link-minus').live('click', function(){
    setTimeout(show_hide_datarecord, 500);
    return false;
  });

  $('select.geo-location, select.data-record-tag').live('change', function(){
    show_hide_datarecord();
  });

  $('.geografical-select .link-minus').live('click', function(){
    var block = $(this).parent().parent();
	  if($(this).attr('href') != '#'){
	    block.replaceWith("<input type='hidden' name='" + $(this).attr('href').substr(1) + "' value=1 />");
	  } else {
      block.remove();
	  }
		return false;
  });

  $('.title-block .link-minus').live('click', function(){
    var block = $(this).parent().parent();
	  if($(this).attr('href') != '#'){
	    block.replaceWith("<input type='hidden' name='" + $(this).attr('href').substr(1) + "' value=1 />");
	  } else {
      block.remove();
	  }
    return false;
  });

  $('.affiliation-remove').live('click', function(){
    var block = $(this).parent();
	  if($(this).attr('href') != '#'){
	    block.replaceWith("<input type='hidden' name='" + $(this).attr('href').substr(1) + "' value=1 />");
	  } else {
      block.remove();
	  }
    return false;
  });

  $('.tag-remove').live('click', function(){
    $(this).parent().remove();
    return false;
  });

  $('.document-type-radio').live('change', function(){
    var $this = $(this);
    $this.parent().
      siblings(':first').
      children(':first').
      removeClass('radioAreaChecked').
      addClass('radioArea').
      next().
      removeAttr('checked').
      parent().
      children('div:last').
      hide();
    $this.prev().
      removeClass('radioArea').
      addClass('radioAreaChecked').
      attr('checked', 'checked').
      parent().
      children('div:last').
      show();
    return true;
  });
  
  $('#user_alert_email,#user_alert_sms').click(function(){
    if($('#tags__tag_id').val() == 'All' && $('#locations__location_id').val() == '1'){
    return false;
    }
    return true;
  });

  function hide_alert_links(){
    if($('.box-holder select.alert_tags').length < 2){ $('#del-alert-topic').hide(); } else {  $('#del-alert-topic').show(); }
    if($('.box-holder select.alert_locations').length < 2){ $('#del-alert-location').hide(); } else { $('#del-alert-location').show(); }
    if($('.box-holder select.alert_tags option:selected[value=All]').length == 1 || $('.box-holder select.alert_tags option:selected[value=0]').length >= 1 || $('.box-holder select.alert_tags').length > 16){ $('#add-alert-topic').hide(); } else {$('#add-alert-topic').show();}
    if($('.box-holder select.alert_locations option:selected[value=0]').length == 1){ $('#add-alert-location').hide(); } else {$('#add-alert-location').show();}
    if($('.box-holder select.alert_tags[value=Select Topics]').length == 1 && $('select.alert_locations[value=Select Coverage]').length == 1){
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

  $('select.alert_tags, select.alert_locations').live('change', function(){
    hide_alert_links();
  });

  $('#del-alert-topic, #del-alert-location').live('click', function(){
    hide_alert_links();
  });

  $('#add-alert-topic').live('click', function(){
    hide_alert_links();
    var $item = $('#hidden-new-tag select.alert_tags:last');
    $('.box-holder select.alert_tags:not(:last)').each(function(){
      $item.find('option[value=' + $(this).val() + ']').remove();
    });
  });

  $('#add-alert-location').live('click', function(){
    hide_alert_links();
    var $item = $('#hidden-new-location select.alert_locations:last');
    $('.box-holder select.alert_locations:not(:last)').each(function(){
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
    if($('.alert_locations option:selected[value=0]').length > 1){ $('#add-alert-location').hide(); } else { $('#add-alert-location').show(); }
  }

  $('#user_alert_sms').live('change', show_hide_add_tag);
  $('#add-data-record-tag').click(function(){setTimeout(show_hide_add_tag, 250);});
  $('#add-alert-location').click(function(){setTimeout(show_hide_add_tag, 250);});
  show_hide_add_tag();

  $('#documents_fields .remove_link').live('click', function(){
    if($('#documents_fields .remove_link:visible').length == 0){ $('#documents_fields .add_another').show(); setTimeout("$('#documents_fields .add_another').show();", 500); }
  });

  $('#new_data_record').submit(function(){
    $('#documents_fields li:hidden:not(.add_another)').remove();
    return true;
  });
  
});
