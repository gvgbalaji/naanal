<?php // Inialize session
session_start();

// Include database connection settings
include ('config.inc');
include ('arrays.inc');
if (!isset($_SESSION['username'])) {

	$login = mysql_query("SELECT * FROM naanal.user WHERE (username = '" . mysql_real_escape_string($_POST['username']) . "') and (password = '" . mysql_real_escape_string(md5($_POST['password'])) . "')");
	//$tenant=mysql_query("SELECT tenant FROM user WHERE (username = '" . mysql_real_escape_string($_POST['username']) . "') and (password = '" . mysql_real_escape_string(md5($_POST['password'])) . "')");
	$tenant = mysql_result($login, 0, 2);
	$squid_ip = mysql_result(mysql_query("select ip_addr from naanal.tenant_ip where tenant='$tenant' and app_nm='squid'"), 0, 0);
	// Check username and password match
	if (!(mysql_num_rows($login) == 1)) {

		// Jump to secured page
		header('Location: index.php');
	}

	// Retrieve username and password from database according to user's input
	else {
		// Set username session variable
		$_SESSION['username'] = $_POST['username'];
		$_SESSION['tenant'] = $tenant;
		$_SESSION['squid_ip'] = $squid_ip;
		
		$_SESSION['auth_cmd'] =$auth_cmd."http://$squid_ip:35357/v2.0";
		
		//$_SESSION['con2'] = mysql_connect($squid_ip, "root", "password");
		//$con2 = mysql_connect($_SESSION['squid_ip'], "root", "password");

	}

}
?>