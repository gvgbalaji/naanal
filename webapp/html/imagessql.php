<?php
require 'loginproc.php';
$auth_cmd = $_SESSION['auth_cmd'];
$fn = $_GET['fn'];
$img_nm = $_GET['img_nm'];
$df = $_GET['df'];
$fl_nm = $_GET['fl_nm'];

$id = $_GET['id'];

if ($fn == 'add') {
	$target_path = "/opt/naanal/images/" . $fl_nm;
	$cmd = "glance $auth_cmd image-create --name=$img_nm --container-format=bare --disk-format=$df --file=$target_path ";
	exec($cmd);
	//echo $cmd;
} elseif ($fn == 'del') {
	$cmd = "glance $auth_cmd image-delete $id";
	exec($cmd);
	//echo $cmd;
} elseif ($fn == 'del1') {

	$tmp = str_replace("'", "", $id);
	$tmp = str_replace("(select,", "", $tmp);
	$tmp = str_replace("select", "", $tmp);
	$tmp = str_replace("(", "", $tmp);
	$tmp = str_replace(")", "", $tmp);
	$arr = explode(",", $tmp);
	foreach ($arr as $val) {
		if (!empty($val)) {
			$cmd = "glance $auth_cmd image-delete $id";
			exec($cmd);
			//echo $cmd;
		}
	}

} elseif ($fn == 'update') {
	$cmd = "glance $auth_cmd image-update --name=$img_nm $id";
	//exec($cmd);
	//echo $cmd;
}

//$query = "select id,name,round(size/(1024*1024)) from glance.images where deleted=0;";
$query = "select id as keyval,name,round(size/(1024*1024)),(SELECT value FROM glance.image_locations where image_id=keyval and deleted=0),disk_format from glance.images where deleted=0;";
$result = mysql_query($query, $con2);

echo "<input type='button' class='addel-button' value='Add' onclick='imageadd()'/>&nbsp;&nbsp;<input type='button' class='addel-button' onclick='delconf(imagessql,\"del1\")' value='Delete'/>";
echo "<table id ='instance_tbl'><tr><th><input type='checkbox' name='group' id='selectall' onclick='selectall()'></th><th>Image Name</th><th>Size (MB)</th><th>Download</th><th>Manage</th></tr>";
while ($row = mysql_fetch_array($result)) {
	if ( substr($row[3], 0,8) =='file:///') {
		$row[3]=str_replace('file:///var/lib/', '', $row[3]);
	}
	if($row[4]=="qcow2"){
		$row[4]="img";
	}
	echo "<tr><td><input type='checkbox' id='" . $row[0] . "' value='" . $row[0] . "' name='group' ></td><td>$row[1]</td><td>$row[2]</td><td><a href='$row[3]' download='$row[1].$row[4]' ><img class='vdi_btn_img' src='images/download.ico' /></a></td><td><img class='set' src='delete.png' onclick=" . '"delconf(imagessql,' . "'del'" . ',' . "'$row[0]'" . ')"' . "/></td></tr>";
}
echo "</table>";
mysql_close($con2);
?>
