<html>
	<head>

		<?php
		require 'loginproc.php';
		include 'arrays.inc';
		?>
	</head>
	<body >
		<input type="button" value="Shutdown" onclick="host_shutdown()" />
		<input type="button" value="Restart" onclick="host_restart()" />
		<input type="button" value="Backup" onclick="host_backup()" />
		<input type="button" value="Initial Configuration" onclick="configadd()" />
	</body>
</html>
