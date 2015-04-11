<?php
$df = $_POST['df'];

function getext($img) {
	$name = strtolower($img);
	$data = explode(".", $name);
	$ext = count($data) - 1;
	return $data[$ext];
}

if (isset($_FILES)) {
	$allowed = array('iso', 'img', 'vmdk');
	$ext = getext($_FILES['file1']['name']);
	$size = $_FILES['file1']['size'];
	if (in_array($ext, $allowed)) {

		$name = basename($_FILES['file1']['name']);
		$target_path = "/opt/naanal_images/" . $name;
		if (!file_exists($target_path)) {
			if (move_uploaded_file($_FILES['file1']['tmp_name'], $target_path)) {
				echo '<input type="hidden" id="fl_nm" value="' . $name . '">';
				echo 'File Uploaded Successfully ';
				if ($ext != "img" && $df != "qcow2") {

					if ($ext != $df) {
						echo "Please Select $ext format in Select Menu ";
					}
				}
			} else {
				echo "File upload has an error " ;
			}
		} else {
			echo "file with same name($name)  already exists <br/>";
			echo '<input type="hidden" id="fl_nm" value="' . $name . '">';
			if ($ext != "img" && $df != "qcow2") {

				if ($ext != $df) {
					echo "Please Select $ext format in Select Menu ";
				}
			}
		}

	} else {
		echo "$ext file type not allowed".$_FILES['file1']['name']." ".$_FILES['file1']['size'];
	}
} else {
	echo "Error";
}
?>

