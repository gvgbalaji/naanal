<?php
include 'arrays.inc';
require 'loginproc.php';
require 'blockuser.php';

$fn = $_GET['fn'];

$login_nm = $_GET['login_nm'];
$passwd = $_GET['passwd'];
$usr_nm = $_GET['usr_nm'];
$ins_nm = $_GET['ins_nm'];
$admin_flag = $_GET['usr_type'];
$prev_passwd = $_GET['prev_passwd'];

if ($fn == 'add') {

	$num_rows = mysql_result(mysql_query("select count(*) from naanal.user where username='$login_nm'", $con2), 0);
	if ($num_rows == 0) {

		$query = "insert into naanal.user values('$login_nm',md5('$passwd'),'$usr_nm','$ins_nm',$admin_flag)";
		$result = mysql_query($query, $con2);

	}
} elseif ($fn == 'edit') {

	if ($passwd == $prev_passwd) {
		$query = "update naanal.user set tenant='$usr_nm',instance='$ins_nm',admin_flag=$admin_flag where username='$login_nm'";
		$result = mysql_query($query, $con2);
	} else {
		$query = "update naanal.user set password=md5('$passwd'),tenant='$usr_nm',instance='$ins_nm',admin_flag=$admin_flag where username='$login_nm'";
		$result = mysql_query($query, $con2);
	}
} elseif ($fn == 'del') {
	$query = "delete from naanal.user where username='$login_nm';";
	$result = mysql_query($query, $con2);
} elseif ($fn == 'del1') {
	$query = "delete from naanal.user where username in '$login_nm';";
	$result = mysql_query($query, $con2);
}
$query = "select * from naanal.user order by tenant";

$result = mysql_query($query, $con2);
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

