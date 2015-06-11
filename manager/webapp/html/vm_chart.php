<?php
include 'arrays.inc';
require ('loginproc.php');

function array_push_assoc($array, $key, $value) {
	$array[$key] = $value;
	return $array;
}

function push_details($name, $value) {
	global $details;
	$details = array_push_assoc($details, $name, $value);
}

$vm_limit = 5;
$ram_val = 80;
$cpu_val = 80;
$disk_val = 4.0;

$host_arr = array();
$details = array();
$critical_net = array();
$critical_cpu = array();
$critical_ram = array();
$critical_disk = array();
$cpu_array = array();
$ram_array = array();
$vm_array = array();
$stpd_vm_array = array();

$total = mysql_result(mysql_query("SELECT count(*) FROM nova.instances where vm_state!='deleted' and deleted=0;",$con2), 0, 0);
$running = mysql_result(mysql_query("SELECT count(*) FROM nova.instances where vm_state!='deleted' and deleted=0 and power_state=1;", $con2), 0, 0);
$stopped = $total - $running;

$stpd_vmq = mysql_query("SELECT display_name FROM nova.instances where vm_state!='deleted' and deleted=0 and power_state!=1", $con2);
while ($stpd_vm = mysql_fetch_array($stpd_vmq)) {
	array_push($stpd_vm_array, $stpd_vm[0]);
}

$vmq = mysql_query("SELECT display_name FROM nova.instances where vm_state!='deleted' and deleted=0 limit $vm_limit", $con2);

while ($vm = mysql_fetch_array($vmq)) {
	array_push($vm_array, $vm[0]);
	$vm_id = mysql_result(mysql_query("SELECT host_object_id FROM nagios.nagios_hosts where display_name='$vm[0]';", $con), 0, 0);

	$disk = NULL;
	$cpu = NULL;
	$ram = NULL;

	//ping
	$pingq = mysql_query("select output,state FROM nagios.nagios_servicechecks where service_object_id=(select service_object_id FROM nagios.nagios_services where host_object_id=$vm_id and display_name='PING'
) order by end_time desc limit 1;", $con);
	$pingstate = mysql_result($pingq, 0, 1);
	if ($pingstate == 0 || $pingstate == 1) {
		$ping = "Running";
	} else {
		array_push($critical_net, $vm[0]);
	}

	//disk
	$diskq = mysql_query("select output,state FROM nagios.nagios_servicechecks where service_object_id=(select service_object_id FROM nagios.nagios_services where host_object_id=$vm_id and display_name='DISK'
	 ) order by end_time desc limit 1;", $con);
	$diskstate = mysql_result($diskq, 0, 1);

	if ($diskstate == 0 || $diskstate == 1 || $diskstate == 2) {
		preg_match('!free \d+\.\d+ Gb!', mysql_result($diskq, 0, 0), $tmp);
		if (sizeof($tmp > 0)) {
			$disk = str_replace(["free ", " Gb"], "", $tmp[0]);

		}
	}

	//cpu
	$cpuq1 = mysql_query("select output,state FROM nagios.nagios_servicechecks where service_object_id=(select service_object_id FROM nagios.nagios_services where host_object_id=$vm_id and display_name='CPU'
	 ) order by end_time desc limit 1;", $con);
	$cpustate = mysql_result($cpuq1, 0, 1);

	if ($cpustate == 0) {
		preg_match('!\d+\%!', mysql_result($cpuq1, 0, 0), $tmp);

		$cpu = str_replace("%", "", $tmp[0]);

	} elseif ($cpustate == 2 || $cpustate == 1) {
		preg_match('!\d+\%!', mysql_result($cpuq1, 0, 0), $tmp);

		if (sizeof($tmp) > 0) {
			$cpu = str_replace("%", "", $tmp[0]);
		}

	}

	//ram
	$ramq1 = mysql_query("select output,state FROM nagios.nagios_servicechecks where service_object_id=(select service_object_id FROM nagios.nagios_services where host_object_id=$vm_id and display_name='RAM'
	 ) order by end_time desc limit 1;", $con);
	$ramstate = mysql_result($ramq1, 0, 1);

	if ($ramstate == 0 || $ramstate == 1 || $ramstate == 2) {
		preg_match_all('!\d+\%!', mysql_result($ramq1, 0, 0), $tmp);
		if (sizeof($tmp[0]) > 1) {
			$ram = str_replace("%", "", $tmp[0][0]);

		}
	}
	if ($cpu >= $cpu_val) {
		$cpu = $cpu . " %";
		$critical_cpu = array_push_assoc($critical_cpu, $vm[0], $cpu);
	}

	if ($disk < $disk_val && $disk != NULL) {
		$disk = $disk . " GB";
		$critical_disk = array_push_assoc($critical_disk, $vm[0], $disk);
	}
	if ($ram >= $ram_val) {
		$ram = $ram . " %";
		$critical_ram = array_push_assoc($critical_ram, $vm[0], $ram);
	}

	array_push($cpu_array, $cpu);
	array_push($ram_array, $ram);

}

push_details("total", $total);
push_details("running", $running);
push_details("stopped", $stopped);
push_details("critical_cpu", sizeof($critical_cpu));
push_details("critical_disk", sizeof($critical_disk));
push_details("critical_ram", sizeof($critical_ram));
push_details("critical_net", sizeof($critical_net));

$host_arr = array_push_assoc($host_arr, "details", $details);
$host_arr = array_push_assoc($host_arr, "critical_cpu_array", $critical_cpu);
$host_arr = array_push_assoc($host_arr, "critical_disk_array", $critical_disk);
$host_arr = array_push_assoc($host_arr, "critical_ram_array", $critical_ram);
$host_arr = array_push_assoc($host_arr, "cpu_array", $cpu_array);
$host_arr = array_push_assoc($host_arr, "ram_array", $ram_array);
$host_arr = array_push_assoc($host_arr, "vm_array", $vm_array);
$host_arr = array_push_assoc($host_arr, "stpd_vm_array", $stpd_vm_array);

$host_json = json_encode($host_arr);
echo $host_json;
?>