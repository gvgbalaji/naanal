<?php
include 'arrays.inc';
require ('loginproc.php');

$data_limit = 5;

function array_push_assoc($array, $key, $value) {
	$array[$key] = $value;
	return $array;
}

function push_arr($name, $value) {
	global $tmp_status_arr;
	$tmp_status_arr = array_push_assoc($tmp_status_arr, $name, $value);
}

function push_details($name, $value) {
	global $details;
	$details = array_push_assoc($details, $name, $value);
}

$host_arr = array();
$details = array();
$ping = "<span class='critical'>Not Running</span>";
$uptime = "-";
$disk = "-";
$cpu = "-";
$ram = "-";

$controller = mysql_query("SELECT display_name,address,host_object_id FROM nagios.nagios_hosts where display_name='openstack';", $con);

while ($row = mysql_fetch_row($controller)) {

	//ping
	$pingq = mysql_query("select output,state FROM nagios.nagios_servicechecks where service_object_id=(select service_object_id FROM nagios.nagios_services where host_object_id=$row[2] and display_name='PING'
) order by end_time desc limit 1;", $con);
	$pingstate = mysql_result($pingq, 0, 1);
	if ($pingstate == 0 || $pingstate == 1) {
		$ping = "Running";
	} 
	//uptime
	$uptimeq = mysql_query("select output,state FROM nagios.nagios_servicechecks where service_object_id=(select service_object_id FROM nagios.nagios_services where host_object_id=$row[2] and display_name='UPTIME'
	 ) order by end_time desc limit 1;", $con);
	$uptimestate = mysql_result($uptimeq, 0, 1);
	if ($uptimestate == 0 || $uptimestate == 1) {
		preg_match_all('!\d+!', mysql_result($uptimeq, 0, 0), $tmp);
		$uptime = $tmp[0][2] . " Minutes";

		if ($tmp[0][0] > 0) {
			if ($tmp[0][0] == 1) {

				$uptime = $tmp[0][0] . " Day " . $tmp[0][1] . " Hours ";

			} else {
				$uptime = $tmp[0][0] . " Days " . $tmp[0][1] . " Hours ";
			}
		} elseif ($tmp[0][1] > 0) {
			if ($tmp[0][1] == 1) {

				$uptime = $tmp[0][1] . " Hour " . $uptime;
			} else {
				$uptime = $tmp[0][1] . " Hours " . $uptime;
			}

		}

	}

	//disk
	$diskq = mysql_query("select output,state FROM nagios.nagios_servicechecks where service_object_id=(select service_object_id FROM nagios.nagios_services where host_object_id=$row[2] and display_name='DISK'
	 ) order by end_time desc limit 1;", $con);
	$diskstate = mysql_result($diskq, 0, 1);

	if ($diskstate == 0 || $diskstate == 1) {
		preg_match('!\d+ MB!', mysql_result($diskq, 0, 0), $tmp);
		$tmp[0] = str_replace(" MB", "", $tmp[0]);
		$disk = round($tmp[0] / 1024) . "GB";
		if ($diskstate == 1) {
			$disk = '<span class="warning">' . $disk . '</span>';
		}
	} elseif ($diskstate == 2) {
		preg_match('!\d+ MB!', mysql_result($diskq, 0, 0), $tmp);
		$tmp[0] = str_replace(" MB", "", $tmp[0]);
		if (sizeof($tmp) > 0) {
			$disk = '<span class="critical">' . round($tmp[0] / 1024) . 'GB</span>';
		}
	}

	//cpu
	$cpuq1 = mysql_query("select output,state FROM nagios.nagios_servicechecks where service_object_id=(select service_object_id FROM nagios.nagios_services where host_object_id=$row[2] and display_name='CPU'
	 ) order by end_time desc limit 1;", $con);
	$cpustate = mysql_result($cpuq1, 0, 1);

	if ($cpustate == 0 || $cpustate == 1) {
		preg_match('!\d+%!', mysql_result($cpuq1, 0, 0), $tmp);
		$cpu = $tmp[0];
		if ($cpustate == 1) {
			$cpu = '<span class="warning">' . $cpu . '</span>';
		}
	} elseif ($cpustate == 2) {
		preg_match('!\d+\%!', mysql_result($cpuq1, 0, 0), $tmp);
		if (sizeof($tmp) > 0) {
			$cpu = '<span class="critical">' . $tmp[0] . '</span>';
		}
	}

	//ram
	$ramq1 = mysql_query("select output,state FROM nagios.nagios_servicechecks where service_object_id=(select service_object_id FROM nagios.nagios_services where host_object_id=$row[2] and display_name='RAM'
	 ) order by end_time desc limit 1;", $con);
	$ramstate = mysql_result($ramq1, 0, 1);

	if ($ramstate == 0 || $ramstate == 1) {
		preg_match_all('!\d+!', mysql_result($ramq1, 0, 0), $tmp);
		if ($ramstate == 1) {
			$tmp[0][2] = '<span class="warning">' . $tmp[0][2] . '</span>';
		}
		$ram = $tmp[0][2] . "% (" .round($tmp[0][1] / 1024,2) . " GB/" . round($tmp[0][0] / 1024) . " GB )";

	} elseif ($ramstate == 2) {
		preg_match_all('!\d+!', mysql_result($ramq1, 0, 0), $tmp);
		if (sizeof($tmp[0]) > 1) {

			$ram = '<span class="critical">' . $tmp[0][2] . "% </span>(" .round( $tmp[0][1] / 1024 , 2) . " GB/" . round($tmp[0][0] / 1024) . " GB )";
		}
	}

	push_details("name", $row[0]);
	push_details("ip", $row[1]);
	push_details("status", $ping);
	push_details("uptime", $uptime);
	push_details("disk", $disk);
	push_details("cpu", $cpu);
	push_details("ram", $ram);

	$host_arr = array_push_assoc($host_arr, "details", $details);

	//cpu_arr
	$cpuq = mysql_query("select end_time,output,state FROM nagios.nagios_servicechecks where service_object_id=(select service_object_id FROM nagios.nagios_services where host_object_id=$row[2] and display_name='CPU'
	 ) order by end_time desc limit $data_limit; ", $con);

	$cpu_time = array();
	$cpu_val = array();

	while ($cpu_row = mysql_fetch_array($cpuq)) {
		array_push($cpu_time, "$cpu_row[0]");
		$val = NULL;

		if ($cpu_row[2] == 0 || $cpu_row[2] == 1) {
			preg_match('!\d!', $cpu_row[1], $tmp);
			$val = $tmp[0];
		} elseif ($cpu_row[2] == 2) {
			preg_match('!\d+\%!', $cpu_row[1], $tmp1);
			if (sizeof($tmp1) > 0) {
				$val = str_replace("%", '', $tmp1[0]);
			}
		}

		array_push($cpu_val, $val);

	}
	$cpu_obj = array("cpu_time" => $cpu_time, "cpu_usage" => $cpu_val);

	$host_arr = array_push_assoc($host_arr, "CPU", $cpu_obj);

	//ram_arr
	$ramq = mysql_query("select end_time,output,state FROM nagios.nagios_servicechecks where service_object_id=(select service_object_id FROM nagios.nagios_services where host_object_id=$row[2] and display_name='RAM'
) order by end_time desc limit $data_limit; ", $con);

	$ram_time = array();
	$ram_val = array();

	while ($ram_row = mysql_fetch_array($ramq)) {
		array_push($ram_time, "$ram_row[0]");
		$val = NULL;

		if ($ram_row[2] == 0 || $ram_row[2] == 1) {
			preg_match_all('!\d+!', $ram_row[1], $tmp);
			$val = $tmp[0][2];
		} elseif ($ram_row[2] == 2) {
			preg_match_all('!\d+!', $ram_row[1], $tmp1);
			if (sizeof($tmp1[0]) > 1) {
				$val = $tmp1[0][2];
			}
		}
		array_push($ram_val, $val);

	}
	$ram_obj = array("ram_time" => $ram_time, "ram_usage" => $ram_val);

	$host_arr = array_push_assoc($host_arr, "RAM", $ram_obj);

}

$host_json = json_encode($host_arr);
echo $host_json;
?>
