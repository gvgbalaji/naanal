<?php
include 'arrays.inc';
require 'loginproc.php';
require 'blockuser.php';
include 'zmq_fn.php';

$fn = $_GET['fn'];

$login_nm = $_GET['login_nm'];
$passwd = $_GET['passwd'];
$usr_nm = $_GET['usr_nm'];
$ins_nm = $_GET['ins_nm'];
$admin_flag = $_GET['usr_type'];
$prev_passwd = $_GET['prev_passwd'];

function rdp_fn($action, $nm, $ip, $user = "root") {
	$filename = "rdp/$nm.rdp";
	if ($action == "add") {
		if (file_exists($filename)) {
			unlink($filename);
		}
		$content = file_get_contents("rdp/template.rdp");
		$content = str_replace("FLOATING_IP", $ip, $content);
		$content = str_replace("USER", $user, $content);
		file_put_contents($filename, $content);

	} elseif ($action == "delete") {
		if (file_exists($filename)) {
			unlink($filename);
		}
	}
}

if ($fn == 'add') {

	$num_rows = mysql_result(mysql_query("select count(*) from naanal.user where username='$login_nm'", $con), 0);
	if ($num_rows == 0) {

		$query = "insert into naanal.user values('$login_nm',md5('$passwd'),'$usr_nm','$ins_nm',$admin_flag)";
		$result = mysql_query($query, $con);

		if ($admin_flag == 0) {
			$query = "SELECT (select floating_ip_address from neutron.floatingips where fixed_port_id = (select id   from neutron.ports where device_id =uuid ) ) as ip FROM nova.instances where vm_state!='deleted'and deleted=0 and display_name='$ins_nm' ;";
			$flt_ip = mysql_result(mysql_query($query, $con2), 0, 0);

			rdp_fn("add", $login_nm, $flt_ip);

			$cmd = "winexe -U Administrator%password //$flt_ip \"net user $login_nm $passwd /add\"";
			//$arr1 = array('fn' => 'shell', 'cmd' => $cmd);
			//$out = zmq_exec($arr1);
			//echo $cmd;
		}
	}
} elseif ($fn == 'edit') {

	if ($passwd == $prev_passwd) {
		$query = "update naanal.user set tenant='$usr_nm',instance='$ins_nm',admin_flag=$admin_flag where username='$login_nm'";
		$result = mysql_query($query, $con);
	} else {
		$query = "update naanal.user set password=md5('$passwd'),tenant='$usr_nm',instance='$ins_nm',admin_flag=$admin_flag where username='$login_nm'";
		$result = mysql_query($query, $con);
	}

	if ($admin_flag == 0) {
		$query = "SELECT (select floating_ip_address from neutron.floatingips where fixed_port_id = (select id   from neutron.ports where device_id =uuid ) ) as ip FROM nova.instances where vm_state!='deleted'and deleted=0 and display_name='$ins_nm' ;";
		$flt_ip = mysql_result(mysql_query($query, $con2), 0, 0);

		rdp_fn("add", $login_nm, $flt_ip);
	}
} elseif ($fn == 'del') {
	$query = "delete from naanal.user where username='$login_nm';";
	$result = mysql_query($query, $con);

	rdp_fn("delete", $login_nm);

	$cmd = "winexe -U Administrator%password //$flt_ip \"net user $login_nm /delete\"";
	$arr1 = array('fn' => 'shell', 'cmd' => $cmd);
	$out = zmq_exec($arr1);

} elseif ($fn == 'del1') {
	$query = "delete from naanal.user where username in '$login_nm';";
	$result = mysql_query($query, $con);

	$tmp = str_replace("'", "", $login_nm);
	$tmp = str_replace("(select,", "", $tmp);
	$tmp = str_replace("select", "", $tmp);
	$tmp = str_replace("(", "", $tmp);
	$tmp = str_replace(")", "", $tmp);
	$arr = explode(",", $tmp);
	foreach ($arr as $val) {
		if (!empty($val)) {
			rdp_fn("delete", $val);

		}
	}

}
$query = "select * from naanal.user order by tenant";

$result = mysql_query($query, $con);
echo "<input type='button' class='addel-button' value='Add' onclick='useradd()'/>&nbsp;&nbsp;<input type='button' class='addel-button' onclick='delconf(userssql,\"del1\")' value='Delete'/>";
echo "<table><tr><th><input type='checkbox' name='group' id='selectall' onclick='selectall()'></th><th>Full Name</th><th>Username</th><th>Instance</th><th>User Type</th><th>Manage</th></tr>";
while ($row = mysql_fetch_array($result)) {
	if ($row[4] == 1) {
		$user_type = "Admin";
	} else {
		$user_type = "User";
	}
	echo "<tr><td><input type='checkbox' id='" . $row[1] . "' value='" . $row[1] . "' name='group' ></td><td>$row[2]</td><td>$row[0]</td><td>$row[3]</td><td>$user_type</td><td><img class='set' src='settings.png' onclick=" . '"useradd(' . "'add' , '$row[0]' , '$row[1]', '$row[2]','$row[3]','$row[4]' " . ')"' . "/><img class='set' src='delete.png' onclick=" . '"delconf(userssql,' . "'del'" . ',' . "'$row[0]'" . ')"' . "/></td></tr>";
}
echo "</table>";
?>

