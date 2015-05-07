<html>
	<head>
		<?php

		require 'loginproc.php';
		$flt_ip_stat = $_GET['flt_ip_chk'];
		?>
	</head>
	<body>
		<form id="instanceform" action="javascript:instancessql('add')">

			<table id="tblband">
				<caption id="pol">
					Add Instances
				</caption>

				<tr id="ins_nm_tr">
					<td class="leftd">Instance Name:</td><td>
					<input type="text"  id="ins_nm" name="ins_nm" required="required" pattern="[a-zA-Z0-9_.]+" title="Alphanumeric,Underscore and period only allowed" maxlength="25"/>
					</td>
				</tr>

				<tr id="img_nm_tr">
					<td class="leftd">Image:</td><td>
					<select id='img_nm'>
						<?php
						$result = mysql_query("select id,name from glance.images where deleted=0 order by size", $con2);
						while ($row = mysql_fetch_array($result)) {
							echo "<option id='" . $row[0] . "' value='" . $row[0] . "'>$row[1]</option>";

						}
						?>
					</select></td>
				</tr>
				<tr id ='flv_nm_tr'>
					<td class="leftd">Flavor:</td><td>
					<select id='flv_nm'>
						<?php
						$result = mysql_query("select flavorid,name,memory_mb,root_gb from nova.instance_types where deleted=0 order by memory_mb", $con2);
						while ($row = mysql_fetch_array($result)) {
							if ($row[2] > 1023) {
								$row[2] = ($row[2] / 1024) . "GB";
							} else {
								$row[2] = $row[2] . "MB";
							}
							echo "<option id='" . $row[0] . "' value='" . $row[0] . "'>$row[1] RAM:$row[2] HD:$row[3]GB</option>";

						}
						?>
					</select></td>
				</tr>

				<tr id="ins_count_tr">
					<td class="leftd">Instance Count:</td><td>
					<input type="number"  id="ins_count" name="ins_count" min=1 max=50  value=1 />
					</td>
				</tr>

				<tr id="sec_grp_tr">
					<td class="leftd">Security Group:</td><td>
					<select id='sec_grp'>
						<option id='default' value='default'>default</option>
						<?php
						$result = mysql_query("select name from neutron.securitygroups where name!='default'", $con2);
						while ($row = mysql_fetch_array($result)) {
							echo "<option id='" . $row[0] . "' value='" . $row[0] . "'>$row[0]</option>";

						}
						?>
					</select></td>
				</tr>
				<tr id="flt_ip_tr">
					<td class="leftd">Floating ip:</td><td>
					<select id='flt_ip'>
						<option id='none' value='none'></option>
						<?php
						$fltr = "";
						if (isset($flt_ip_stat)) {
							$fltr = "or floating_ip_address='$flt_ip_stat'";
						}
						$result = mysql_query("select floating_ip_address from neutron.floatingips where status ='DOWN' $fltr  order by floating_ip_address ;", $con2);
						while ($row = mysql_fetch_array($result)) {
							echo "<option id='" . $row[0] . "' value='" . $row[0] . "'>$row[0]</option>";

						}
						?>
					</select></td>
				</tr>
				<tr>
					<td class="leftd">Autostart Enabled</td><td>
					<input type="checkbox" id="auto_start" checked  />					
					</td>
				</tr>

				<tr>
					<td>&nbsp;</td><td>&nbsp;</td>
				</tr>
				<tr>
					<td class="leftd"></td>
					<td>
					<input type="submit" value="OK"  id="add_button" class="addel-button" />
					<input type="button" value="CANCEL" id='del' onclick='instancessql()' class="addel-button"/>
					<input type="hidden" id="limit_session" value="" />
					</td>
				</tr>

			</table>
			<input type="hidden" id="org_ins_nm" value=""/>
			<input type="hidden" id="org_flv_nm" value=""/>
			<input type="hidden" id="org_flt_ip" value=""/>
			</div>

		</form>
	</body>
</html>
