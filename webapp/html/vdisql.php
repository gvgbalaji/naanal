<?php
require 'loginproc.php';
$auth_cmd=$_SESSION['auth_cmd'];

$con2=mysql_connect($_SESSION['squid_ip'],"root","password");

$result=mysql_query("SELECT display_name,(select floating_ip_address from neutron.floatingips where fixed_port_id = (select id   from neutron.ports where device_id =uuid ) )as External_ip,(select ip_address from neutron.ipallocations where port_id = (select id  from neutron.ports where device_id =uuid ) )as Internal_ip,power_state,vm_state,task_state,memory_mb as allocated_ram,root_gb as allocated_harddisk FROM nova.instances where vm_state!='deleted';",$con2);



//echo $_SESSION['squid_ip'];
echo "<input type='button' class='addel-button' value='Add' onclick='instanceadd()'/>&nbsp;&nbsp;<input type='button' class='addel-button' onclick='delconf(instancedel,\"del1\")' value='Delete'/>";
echo "";
echo "<table id ='instance_tbl'><tr><th><input type='checkbox' name='group' id='selectall' onclick='selectall()'></th><th>Instance Name</th><th>External IP</th><th>Internal IP</th><th>Status</th><th>RAM</th><th>Harddisk</th><th>Manage</th></tr>";
while ($row = mysql_fetch_array($result)) {
	$row[3]=$power_state[$row[3]];
	echo "<tr><td><input type='checkbox' id='" . $row[0] . "' value='" . $row[0] . "' name='group' ></td><td>$row[0]</td><td>$row[1]</td><td>$row[2]</td><td>$row[3]-$row[4]-$row[5]</td><td>$row[6]</td><td>$row[7]</td><td><img class='set' src='settings.png' onclick=" . '"ruleadd(' . "'add' , '$row[0]' , '$row[1]', '$row[2]','$row[3]','$row[4]','$row[5]','$row[6]','$row[7]' " . ')"' . "/><img class='set' src='delete.png' onclick=" . '"delconf(rulessql,' . "'del'" . ',' . "'$row[0]'" . ')"' . "/></td></tr>";
}
echo "</table>";


?>