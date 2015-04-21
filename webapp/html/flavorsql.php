<?php
require 'loginproc.php';

$fn = $_GET['fn'];
$flv_nm = $_GET['flv_nm'];
$flv_id = $_GET['flv_id'];
$ram = $_GET['ram'];
$disk = $_GET['disk'];
$vcpu = $_GET['vcpu'];

$auth_cmd = $_SESSION['auth_cmd'];

$q1 = "SELECT flavorid,name,memory_mb,root_gb,vcpus FROM nova.instance_types where deleted=0 order by flavorid";

function flavoradd($flv_nm, $flv_id, $ram, $disk, $vcpu) {
	global $auth_cmd;
	$cmd = "nova $auth_cmd flavor-create $flv_nm $flv_id $ram $disk $vcpu";
	//echo $cmd;
	exec($cmd);
}

function flavordelete($flv_id) {
	global $auth_cmd;
	$cmd = "nova $auth_cmd flavor-delete $flv_id";
	//echo $cmd;
	exec($cmd);
}

if ($fn == 'add') {
	flavoradd($flv_nm, $flv_id, $ram, $disk, $vcpu);
} elseif ($fn == 'edit') {
	flavordelete($flv_nm);
	flavoradd($flv_nm, $flv_id, $ram, $disk, $vcpu);
} elseif ($fn == 'del') {
	flavordelete($flv_id);
} elseif ($fn == 'del1') {

	$tmp = str_replace("'", "", $flv_id);
	$tmp = str_replace("(select,", "", $tmp);
	$tmp = str_replace("select", "", $tmp);
	$tmp = str_replace("(", "", $tmp);
	$tmp = str_replace(")", "", $tmp);
	$arr = explode(",", $tmp);
	foreach ($arr as $val) {
		if (!empty($val)) {
			flavordelete($val);
		}
	}

}

$result = mysql_query($q1, $con2);

echo "<input type='button' class='addel-button' value='Add' onclick='flavoradd()'/>&nbsp;&nbsp;<input type='button' class='addel-button' onclick='delconf(flavorssql,\"del1\")' value='Delete'/>";
echo "<table id ='instance_tbl'><tr><th><input type='checkbox' name='group' id='selectall' onclick='selectall()'></th><th>ID</th><th>Flavor Name</th><th>RAM</th><th>Disk</th><th>VCpus</th><th>Manage</th></tr>";
while ($row = mysql_fetch_array($result)) {
	echo "<tr><td><input type='checkbox' id='" . $row[0] . "' value='" . $row[0] . "' name='group' ></td><td>$row[0]</td><td>$row[1]</td><td>$row[2]</td><td>$row[3]<td>$row[4]</td><td><img class='set' src='settings.png' onclick=" . '"flavoradd(' . "'add' , '$row[0]' , '$row[1]', '$row[2]','$row[3]','$row[4]' " . ')"' . "/><img class='set' src='delete.png' onclick=" . '"delconf(flavorssql,' . "'del'" . ',' . "'$row[0]'" . ')"' . "/></td></tr>";
}
echo "</table>";
mysql_close($con2);
?>