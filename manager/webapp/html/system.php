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
	</body>
</html>
