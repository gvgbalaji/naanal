<html>
	<head>
		<?php
		include 'arrays.inc';
		require ("loginproc.php");
		require ("blockadmin.php");

		$user = $_SESSION['username'];
		$auth_cmd = $_SESSION['auth_cmd'];

		$ser = mysql_result(mysql_query("select instance from naanal.user where username='$user'", $con2), 0, 0);

		$cmd = "nova $auth_cmd get-vnc-console $ser novnc | awk '{split($4,a,\"Url\");print a[1] }' | awk '/http/'";
		exec($cmd, $output, $result);

		$ins = $output[0];
		?>
		<title>Naanal Technologies</title>
		<script language="javascript" src="user_vdi.js"></script>
		<script src="js/jquery.js" ></script>
		<script src="js/jquery-ui-1.11.1/jquery-ui.js"></script>

		<link rel="stylesheet" href="js/jquery-ui-1.11.1/jquery-ui.css">
		<link rel="stylesheet" href="js/jquery-ui-1.11.1/jquery-ui.theme.css"/>
		<link rel="stylesheet" href="js/jquery-ui-1.11.1/jquery-ui.structure.css"/>
		<link rel="stylesheet" href="home.css"/>
	</head>

	<body  >
		<div>

			<div id="header" class="home"><img class="home" id="logo" src="naanal.png"/>
				<a href="#" id="logoutText" onclick="location.href='logout.php'">Logout</a>
				<input type="image" id="logout" src="logout.ico" onclick="location.href='logout.php'"/>
				<div id="welcome">
					<?php $welcome = "Welcome " . ucfirst($_SESSION['name']);
					echo $welcome;
					?>
				</div>

			</div>

		</div>
		<div id="table2">
			<div>
				
				<a href="<?php echo "rdp/$user.rdp"; ?>"><input type="button" value="RDP" class="leftnav-button" /></a>
				<input type="button" value="Start" onclick="user_action('start')" class="leftnav-button" />
				<input type="button" value="Stop" onclick="user_action('stop')"class="leftnav-button" />
				<input type="button" value="Reboot" onclick="user_action('reboot')"class="leftnav-button" />
			</div>

			<div id="in_table"><iframe id="ifr"  width="90%" height="600px" src="<?php echo $ins; ?>"></iframe></div>

		</div>

		<div id="footer">
			© Naanal Technologies
		</div>

	</body>
</html>
