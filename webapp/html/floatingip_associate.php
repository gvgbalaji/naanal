<html>
	<head>
		<?php
		require 'loginproc.php';
		$auth_cmd = $_SESSION['auth_cmd'];

		//$servq = "select display_name from nova.instances where deleted = 0";
		$servq = "SELECT display_name,(select floating_ip_address from neutron.floatingips where fixed_port_id = (select id   from neutron.ports where device_id =uuid ) ) as ip FROM nova.instances where vm_state!='deleted';";
		$result1 = mysql_query($servq, $con2);
		?>
	</head>
	<body>
		<table id="tblband">
			<caption id="wf_p">
				Associate Floating IP
			</caption>
			<tr>
				<td class="leftd">Floating IP:</td><td>
				<input type="text"  id="flt_ip" required="required"/>
				</td>
			</tr>
			<tr>
				<td class="leftd">Instance Name:</td>
				<td>
				<select class='server' id='ser'>
					<?php
					while ($row = mysql_fetch_array($result1)) {
						if (!isset($row[1])) {
							echo "<option id='$row[0]' value='$row[0]' >$row[0]</option>";
						}
					}
					?>
				</select></td>
			</tr>
			<tr>
				<td></td><td>
				<input type='button' onclick='floatingipsql("asc_add")' value='OK'/>
				&nbsp
				<input type='button' onclick='floatingipsql()' value='Cancel'/>
				</td>
			</tr>
		</table>

	</body>
</html>