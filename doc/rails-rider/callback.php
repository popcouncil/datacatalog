<?php
// Sanity check
if($_POST['action'] != 'save' and $_POST['action'] != 'destroy'){ die('BAD ACTION'); }
if(empty($_POST['payload'])){ die('NO DATA');}

// Start!
require '../../../wp-config.php';
require '../../../wp-includes/registration.php';

$keycode = get_option('rails-rider_keycode');
$payload = json_decode(openssl_decrypt(base64_decode($_POST['payload']), 'AES-128-CBC', sha1($keycode, true), true), true);

if($_POST['action'] == 'save'){
  wp_die(rails_rider($payload));
}

if($_POST['action'] == 'destroy'){
  wp_die(wp_delete_user($payload));
}


/* Edited from wp-includes/registration.php to allow insertion using ids */
function rails_rider($userdata) {
	global $wpdb;

	extract($userdata, EXTR_SKIP);
  if(get_userdata($ID)){ // ID already exists, insert will fail go to update
    return wp_update_user($userdata);
  }
	// (We're always creating)
	$update = false;
	// Hash the password
	$user_pass = wp_hash_password($user_pass);

	$user_login = sanitize_user($user_login);
	$user_login = apply_filters('pre_user_login', $user_login);

	//Remove any non-printable chars from the login string to see if we have ended up with an empty username
	$user_login = trim($user_login);

	if ( empty($user_login) )
		return new WP_Error('empty_user_login', __('Cannot create a user with an empty login name.') );

	if ( !$update && username_exists( $user_login ) )
		return new WP_Error('existing_user_login', __('This username is already registered.') );

	if ( empty($user_nicename) )
		$user_nicename = sanitize_title( $user_login );
	$user_nicename = apply_filters('pre_user_nicename', $user_nicename);

	if ( empty($user_url) )
		$user_url = '';
	$user_url = apply_filters('pre_user_url', $user_url);

	if ( empty($user_email) )
		$user_email = '';
	$user_email = apply_filters('pre_user_email', $user_email);

	if ( !$update && ! defined( 'WP_IMPORTING' ) && email_exists($user_email) )
		return new WP_Error('existing_user_email', __('This email address is already registered.') );

	if ( empty($display_name) )
		$display_name = $user_login;
	$display_name = apply_filters('pre_user_display_name', $display_name);

	if ( empty($nickname) )
		$nickname = $user_login;
	$nickname = apply_filters('pre_user_nickname', $nickname);

	if ( empty($first_name) )
		$first_name = '';
	$first_name = apply_filters('pre_user_first_name', $first_name);

	if ( empty($last_name) )
		$last_name = '';
	$last_name = apply_filters('pre_user_last_name', $last_name);

	if ( empty($description) )
		$description = '';
	$description = apply_filters('pre_user_description', $description);

	if ( empty($rich_editing) )
		$rich_editing = 'true';

	if ( empty($comment_shortcuts) )
		$comment_shortcuts = 'false';

	if ( empty($admin_color) )
		$admin_color = 'fresh';
	$admin_color = preg_replace('|[^a-z0-9 _.\-@]|i', '', $admin_color);

	if ( empty($use_ssl) )
		$use_ssl = 0;

	if ( empty($user_registered) )
		$user_registered = gmdate('Y-m-d H:i:s');

	$user_nicename_check = $wpdb->get_var( $wpdb->prepare("SELECT ID FROM $wpdb->users WHERE user_nicename = %s AND user_login != %s LIMIT 1" , $user_nicename, $user_login));

	if ( $user_nicename_check ) {
		$suffix = 2;
		while ($user_nicename_check) {
			$alt_user_nicename = $user_nicename . "-$suffix";
			$user_nicename_check = $wpdb->get_var( $wpdb->prepare("SELECT ID FROM $wpdb->users WHERE user_nicename = %s AND user_login != %s LIMIT 1" , $alt_user_nicename, $user_login));
			$suffix++;
		}
		$user_nicename = $alt_user_nicename;
	}

	$data = compact( 'user_pass', 'user_email', 'user_url', 'user_nicename', 'display_name', 'user_registered', 'user_login', 'ID' );
	$data = stripslashes_deep( $data );

	$wpdb->insert( $wpdb->users, $data );
	$user_id = (int) $wpdb->insert_id;

	update_user_meta( $user_id, 'first_name', $first_name);
	update_user_meta( $user_id, 'last_name', $last_name);
	update_user_meta( $user_id, 'nickname', $nickname );
	update_user_meta( $user_id, 'description', $description );
	update_user_meta( $user_id, 'rich_editing', $rich_editing);
	update_user_meta( $user_id, 'comment_shortcuts', $comment_shortcuts);
	update_user_meta( $user_id, 'admin_color', $admin_color);
	update_user_meta( $user_id, 'use_ssl', $use_ssl);

	foreach ( _wp_get_user_contactmethods() as $method => $name ) {
		if ( empty($$method) )
			$$method = '';

		update_user_meta( $user_id, $method, $$method );
	}

	if ( isset($role) ) {
		$user = new WP_User($user_id);
		$user->set_role($role);
	} elseif ( !$update ) {
		$user = new WP_User($user_id);
		$user->set_role(get_option('default_role'));
	}

	wp_cache_delete($user_id, 'users');
	wp_cache_delete($user_login, 'userlogins');

  do_action('user_register', $user_id);

	return $user_id;
}
