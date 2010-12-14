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
require(ABSPATH . '/wp-includes/pluggable.php');

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
  $callback = get_option('rails-rider_callback');
  $register = get_option('rails-rider_register');
  $updated = '';
  if(isset($_POST['rails-rider_keycode']) and isset($_POST['rails-rider_callback']) and isset($_POST['rails-rider_register'])){
    update_option('rails-rider_keycode', $_POST['rails-rider_keycode']);
    update_option('rails-rider_callback', $_POST['rails-rider_callback']);
    update_option('rails-rider_register', $_POST['rails-rider_register']);
    $keycode = $_POST['rails-rider_keycode'];
    $callback = $_POST['rails-rider_callback'];
    $register = $_POST['rails-rider_register'];
    $updated = "<div id='message' class='updated'><p>Successfully updated settings.</p></div>";
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
    <p>
      <label>Ruby on Rails Callback URL</label>
      <input type="text" name='rails-rider_callback' value="{$callback}" size=100>
      <br>
      <span>This is the url to the ruby on rails site where we will send the update callback whenever a user changes their data or logs into the Wordpress.</span>
    </p>
    <p>
      <label>Ruby on Rails Registration URL</label>
      <input type="text" name='rails-rider_register' value="{$register}" size=100>
      <br>
      <span>This is the url to the ruby on rails site where we will send the user when they click the register link.</span>
    </p>
    <p><input type="submit" name="Submit" class="button-primary" value="Save Secrets"></p>
  </form>
</div>
EOF;
  echo $output;
}

# We are not updating passwords due to the way wordpress haphazardly plays around
# with the user_pass field, we can't get the password before the update unless we hack
# around a lot
function rrdata($user, $login = false){
  if($login){
    $data = array('ID' => $user->ID, 'time' => time());
  } else {
    $data = array('ID' => $user->ID, 'user_login' => $user->user_login, 'user_email' => $user->user_email, 'user_nicename' => $user->user_nicename, 'display_name' => $user->display_name, 'user_url' => $user->user_url);
    if(!empty($_POST['pass1']) and $_POST['pass1'] == $_POST['pass2']){
      $data['user_pass'] = $_POST['pass1'];
    }
  }
  $data = json_encode($data);
  $keycode = get_option('rails-rider_keycode');
  $result = openssl_encrypt($data, 'AES-128-CBC', sha1($keycode, true));
  return $result;
}

function rails_callback($user, $type){
  $rrdata = rrdata($user);
  $curl = curl_init();
  curl_setopt($curl, CURLOPT_URL, get_option('rails-rider_callback'));
  curl_setopt($curl, CURLOPT_POST, true);
  curl_setopt($curl, CURLOPT_POSTFIELDS, array('action' => $type, 'payload' => $rrdata));
  curl_exec($curl);
  curl_close($curl);
}

function rr_save_callback(){
  rails_callback(wp_get_current_user(), 'save');
}

#function rr_destroy_callback(){
#  rails_callback(wp_get_current_user(), 'destroy');
#}

add_action('wp_login', 'rr_save_callback');
add_action('user_register', 'rr_save_callback');
add_action('profile_update', 'rr_save_callback');

function rr_login_cookie(){
  setcookie('login_callback', 'true', time() + 300);
  setcookie('logout_callback', 'false', time() + 300);
}
add_action('wp_login', 'rr_login_cookie');

function rr_logout_cookie(){
  setcookie('logout_callback', 'true', time() + 300);
  setcookie('login_callback', 'false', time() + 300);
}
add_action('wp_logout', 'rr_logout_cookie');

function rr_head_callback(){
  if($_COOKIE['login_callback'] == 'true'){
    $callback_url = get_option('rails-rider_callback');
    $user = wp_get_current_user();
    $rrdata = urlencode(str_replace("\n", '', rrdata($user, true)));
    echo "<script type='text/javascript' src='{$callback_url}?callback=login&payload={$rrdata}'></script>";
  }
  if($_COOKIE['logout_callback'] == 'true'){
    $callback_url = get_option('rails-rider_callback');
    echo "<script type='text/javascript' src='{$callback_url}?callback=logout'></script>";
  }
}
add_action('wp_head', 'rr_head_callback');
add_action('login_head', 'rr_head_callback');
add_action('in_admin_header', 'rr_head_callback');

function rr_register_callback($link){
  $rails_link = get_option('rails-rider_register');
  return (strlen($rails_link) > 0 ? "<li><a href='{$rails_link}'>Register</a></li>" : $link);
}
add_filter('register', 'rr_register_callback'); # Might need to raise the priority
