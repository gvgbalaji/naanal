<?php
include 'arrays.inc';
require 'loginproc.php';
$fn = $_GET['fn'];
$rule_nm = $_GET['rule_nm'];
$org_rule_nm = $_GET['org_rule_nm'];
$rule_id = $_GET['rule_id'];
$description = $_GET['description'];
$src_host = $_GET['src_host'];
$dst_host = $_GET['dst_host'];
$src_port = $_GET['src_port'];
$dst_port = $_GET['dst_port'];
$services = $_GET['services'];
$actn = $_GET['actn'];
$ins_bef = $_GET['ins_bef'];
$ins_aft = $_GET['ins_aft'];
$auth_cmd = $_SESSION['auth_cmd'];

function ruleadd() {
	global $auth_cmd, $policy_nm, $rule_nm, $description, $services, $actn, $src_host, $dst_host, $src_port, $dst_port, $ins_bef, $ins_aft, $con2;
	$exist = mysql_result(mysql_query("select count(name) from neutron.firewall_rules where name='$rule_nm'", $con2), 0, 0);

	if ($exist == 0) {

		$cmd = "neutron $auth_cmd firewall-rule-create --name $rule_nm --protocol $services --action $actn ";

		if (!empty($src_port)) {
			$cmd = $cmd . "--source-port $src_port ";
		}
		if (!empty($dst_port)) {
			$cmd = $cmd . "--destination-port $dst_port ";
		}

		if (!empty($src_host)) {
			$cmd = $cmd . "--source-ip-address $src_host ";
		}
		if (!empty($dst_host)) {
			$cmd = $cmd . "--destination-ip-address $dst_host ";
		}
		if (!empty($description)) {
			$cmd = $cmd . "--description $description ";
		}

		$cmd2 = "&& neutron $auth_cmd firewall-policy-insert-rule $policy_nm $rule_nm ";
		if (!($ins_bef == '123')) {
			$ins_bef_nm = mysql_result(mysql_query("select name from neutron.firewall_rules where position=$ins_bef", $con2), 0, 0);
			$cmd2 = $cmd2 . "--insert-before $ins_bef_nm";
		}
		if (!($ins_aft == '123')) {
			$ins_aft_nm = mysql_result(mysql_query("select name from neutron.firewall_rules where position=$ins_aft", $con2), 0, 0);
			$cmd2 = $cmd2 . "--insert-after $ins_aft_nm";
		}
		//echo $cmd . $cmd2;
		exec($cmd . $cmd2);
	}
}

function ruledelete($rule) {
	global $auth_cmd, $policy_nm;
	$cmd = "neutron $auth_cmd firewall-policy-remove-rule $policy_nm $rule";
	$cmd2 = " && neutron $auth_cmd firewall-rule-delete $rule";
	//echo $cmd . $cmd2;
	exec($cmd . $cmd2);
}

function ruleedit($rule) {

	ruledelete($rule);
	ruleadd();
}

if ($fn == 'add') {
	$q = "SELECT EXISTS(SELECT * FROM rules WHERE rule_nm ='$rule_nm')";
	$res = mysql_fetch_row(mysql_query($q,$con2));
	if (!$res[0]) {
		ruleadd();
	}

} elseif ($fn == 'edit') {
	if (!($ins_bef == '123')) {
		if ($rule_id < $ins_bef) {
			$ins_bef = $ins_bef - 1;
		}
	} else if (!($ins_aft == '123')) {
		if ($rule_id < $ins_aft) {
			$ins_aft = $ins_aft - 1;
		}
	}

	ruleedit($org_rule_nm);

} elseif ($fn == 'del') {
	ruledelete($rule_nm);

} elseif ($fn == 'del1') {

	$tmp = str_replace("'", "", $rule_nm);
	$tmp = str_replace("(select,", "", $tmp);
	$tmp = str_replace("select", "", $tmp);
	$tmp = str_replace("(", "", $tmp);
	$tmp = str_replace(")", "", $tmp);
	$arr = explode(",", $tmp);
	foreach ($arr as $val) {
		if (!empty($val)) {
			ruledelete($val);
		}
	}
}

$q = "select max(position) from neutron.firewall_rules";
$max_row = mysql_result(mysql_query($q, $con2), 0, 0);
$query = "SELECT name,description,source_ip_address,destination_ip_address,source_port_range_min,source_port_range_max,destination_port_range_min,destination_port_range_max,protocol,action,position FROM neutron.firewall_rules order by position;";

$result = mysql_query($query,$con2);
echo "<input type='button' class='addel-button' value='Add' onclick='firewalladd()'/>&nbsp;&nbsp;<input type='button' class='addel-button' onclick='delconf(firewallsql,\"del1\")' value='Delete'/>";
echo "<table ><tr><th><input type='checkbox' name='group' id='selectall' onclick='selectall()'></th><th>Rule Name</th><th>Description</th><th>Source_host</th><th>Destination_host</th><th>Source_port</th><th>Destination_port</th><th>Service</th><th>Action</th><th>Manage</th></tr>";
while ($row = mysql_fetch_array($result)) {
	if ($row[4] != $row[5]) {
		$s_port = $row[4] . ":" . $row[5];
	} else {
		$s_port = $row[4];
	}
	if ($row[6] != $row[7]) {
		$d_port = $row[6] . ":" . $row[7];
	} else {
		$d_port = $row[6];
	}

	$bef = $row[10] + 1;
	$aft = $row[10] - 1;

	if ($row[10] == 1 and $row[10] == $max_row) {
		$aft = "123";
		$bef = "123";
	} elseif ($row[10] == 1) {
		$aft = "123";
	} else if ($row[10] == $max_row) {
		$bef = "123";
	}
	if ($row[8] == "") {
		$row[8] = "any";
	}

	$proto = ucfirst($row[8]);
	$stat = ucfirst($row[9]);

	echo "<tr><td><input type='checkbox' id='" . $row[0] . "' value='" . $row[0] . "' name='group' ></td><td>$row[0]</td><td>$row[1]</td><td>$row[2]</td><td>$row[3]</td><td>$s_port</td><td>$d_port</td><td>$proto</td><td>$stat</td><td><img class='set' src='settings.png' onclick=" . '"firewalladd(' . "'add' , '$row[0]' , '$row[1]', '$row[2]','$row[3]','$s_port','$d_port','$row[8]','$row[9]','$bef','$aft','$row[10]'  " . ')"' . "/><img class='set' src='delete.png' onclick=" . '"delconf(firewallsql,' . "'del'" . ',' . "'$row[0]'" . ')"' . "/></td></tr>";
}
echo "</table>";

mysql_close($con);
?>

