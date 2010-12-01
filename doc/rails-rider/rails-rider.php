<?php
/*
Plugin Name: Rails Rider
Plugin URI: http://threed-staging.heroku.com/
Description: Rails Rider helps integrate your WordPress blog's users with your Ruby on Rails users.
Version: 0.1
Author: Hong Quach
Author URI: http://hybridgroup.com/
License: Copyright Eric Green?
*/


/* Functions needed to populate the admin menu */
add_action('admin_menu', 'rails_rider_menu');

function rails_rider_menu(){
  add_users_page('Rails Rider Options', 'Rails Rider', 'manage_options', 'rails-rider', 'rails_rider_options');
  add_plugins_page('Rails Rider Options', 'Rails Rider', 'manage_options', 'rails-rider', 'rails_rider_options');
}

function rails_rider_options(){
  if (!current_user_can('manage_options'))  {
    wp_die( __('You do not have sufficient permissions to access this page.') );
  }
  $keycode = get_option('rails-rider_keycode');
  $updated = '';
  if(isset($_POST['rails-rider_keycode'])){
    update_option('rails-rider_keycode', $_POST['rails-rider_keycode']);
    $keycode = $_POST['rails-rider_keycode'];
    $updated = "<div id='message' class='updated'><p>Successfully updated keycode.</p></div>";
  }
$output = <<<EOF
<div id="rails-rider-page" class="wrap">
  {$updated}
  <h2>Rails Rider Secret Codes</h2>
  <form name="rails-rider" id='rails-rider' method='post' action=''>
    <p>
      <label>Secret Keycode</label>
      <input type="text" name="rails-rider_keycode" value='{$keycode}' size=100>
      <br>
      <span>This is the code used to store the secret that will be used to decrypt user information that comes from the rails application.<br>I suggest a long random string of letters, numbers, symbols and nonsense.</span>
    </p>
    <p><input type="submit" name="Submit" class="button-primary" value="Save Secrets"></p>
  </form>
</div>
EOF;
  echo $output;
}
