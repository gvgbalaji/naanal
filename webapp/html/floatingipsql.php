<?php
require 'loginproc.php';
$auth_cmd = $_SESSION['auth_cmd'];
$fn = $_GET['fn'];
$flt_ip = $_GET['flt_ip'];
$server = $_GET['server'];

if ($fn == 'add') {
	$cmd = "nova $auth_cmd floating-ip-create wan-net";
	exec($cmd);
	//echo $cmd;
} elseif ($fn == 'dis') {
	$cmd = "nova $auth_cmd floating-ip-disassociate $server $flt_ip";
	exec($cmd);
	//echo $cmd;
} elseif ($fn == 'asc') {
	$cmd = "nova $auth_cmd floating-ip-associate $server $flt_ip";
	exec($cmd);
	//echo $cmd;
} elseif ($fn == 'del') {
	$cmd = "nova $auth_cmd floating-ip-delete $flt_ip";
	exec($cmd);
	//echo $cmd;
} elseif ($fn == 'del1') {

	$tmp = str_replace("'", "", $flt_ip);
	$tmp = str_replace("(select,", "", $tmp);
	$tmp = str_replace("select", "", $tmp);
	$tmp = str_replace("(", "", $tmp);
	$tmp = str_replace(")", "", $tmp);
	$arr = explode(",", $tmp);
	foreach ($arr as $val) {
		if (!empty($val)) {
			$cmd = "nova $auth_cmd floating-ip-delete $val";
			exec($cmd);
			//echo $cmd;
		}
	}

}

$query = "select floating_ip_address,status,(select display_name from nova.instances where uuid=(select device_id from neutron.ports where id=fixed_port_id) ) from neutron.floatingips order by floating_ip_address";
$servq = "select display_name from nova.instances where deleted = 0 and vm_state!='deleted'";

$result = mysql_query($query, $con2);
$result1 = mysql_query($servq, $con2);

$serv_array = array();
while ($row = mysql_fetch_array($result1)) {
	array_push($serv_array,$row[0]);
}

echo "<input type='button' class='addel-button' value='Add' onclick='floatingipsql(\"add\")'/>&nbsp;&nbsp;<input type='button' class='addel-button' onclick='delconf(floatingipsql,\"del1\")' value='Delete'/></td></tr>";
echo "<tr><td id='btd'><table id='intble'><tr><th><input type='checkbox' name='group' id='selectall' onclick='selectall()'></th><th>IP Address</th><th>Instance</th><th colspan=2>Manage</th></tr>";
while ($row = mysql_fetch_array($result)) {
	if ($row[1] != "ACTIVE") {
		$row[1] = "Not Allocated";
		$opt = "Associate";
		$clr = 'Black';
		$opt_var="asc";
	} else {
		$row[1] = "Allocated";
		$opt = "Disassociate";
		$clr = 'Red';
		$opt_var="dis";
	}
	echo "<tr><td><input type='checkbox' value='" . $row[0] . "' name='group' ></td><td>$row[0]</td><td>$row[2]</td>";
	echo "<td><input type='button' class='vdi-btn' onclick='floatingipsql(\"$opt_var\",\"$row[0]\",\"$row[2]\")' value='$opt' title='$opt' style=\"color:$clr\" />";
	echo "</td><td><button title='Delete' class='vdi_btn' id='ip_del' onclick='delconf(floatingipsql,\"del\",\"$row[0]\",\"\",\"$limit\",\"$offset\")'><img class='vdi_btn_img' src='images/delete.ico'/></button></td></tr>";
}
echo "</table>";
mysql_close($con);
?>
