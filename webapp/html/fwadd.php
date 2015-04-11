<html>
	<head>
		<?php
		include 'arrays.inc';

		require 'loginproc.php';
		
		?>
	</head>

	<body>
		<form id="ruleform" action="javascript:firewallsql('add')">

			<table id="tblband" class="ruletbl">
				<caption id="wf_p">
					General Settings
				</caption>
				<tr>
					<td class="subcaption">Rule Name</td><td class="subcaption"></td><td class="subcaption"></td>
				</tr>
				<tr>
					<td class="leftd">Name*</td><td>
					<input type="text"  id="rule_nm" placeholder="Enter Name" required="required"/>
					</td><td></td>
				</tr>
				<tr>
					<td class="leftd">Description </td><td>					<textarea placeholder="Enter a Description" id="description" cols="25" rows="2" ></textarea></td>
					<td></td>
				</tr>

				<tr>
					<td class="subcaption" >Basic Settings</td><td class="subcaption">Source</td><td class="subcaption td3">Destination</td>
				</tr>

				<tr>
					<td class="leftd">Network/Host*</td><td>
					<input type="text"  id="src_host" placeholder="Enter IP address or leave it blank"	pattern="^([0-9]{1,3}\.){3}[0-9]{1,3}($|/(8|16|24|32))$" />
					</td><td>
					<input type="text"  id="dst_host" class="td3" placeholder="Enter IP address or leave it blank"	pattern="^([0-9]{1,3}\.){3}[0-9]{1,3}($|/(8|16|24|32))$"  />
					</td>
				</tr>
				<tr>
					<td class="leftd">Ports*</td><td>
					<input type="text"  id="src_port" placeholder="Enter port number or leave it blank" />
					</td><td>
					<input type="text"   id="dst_port" class="td3" placeholder="Enter port number or leave it blank" />
					</td>
				</tr>

				<tr>
					<td class="leftd">Services*</td>
					<td>
					<select id="services">
						<option id="tcp" value="tcp">TCP</option>
						<option id="udp" value="udp">UDP</option>
						<option id="icmp" value="icmp">ICMP</option>
						<option id="any" value="any">ANY</option>
					</select></td>
					<td></td>
				</tr>

				<tr>
					<td class="leftd">Insert Before</td>
					<td>
					<select id="ins_bef" onchange="fw_change(this.value)">
						<option id="123" value="123">&nbsp&nbsp</option>
						<?php
						$result = mysql_query("select name,position from neutron.firewall_rules order by position",$con2);
						while ($row = mysql_fetch_array($result)) {
							echo "<option id='" . $row[1] . "' value='" . $row[1] . "'>$row[0]</option>";

						}
						?>
					</select></td>
					<td></td>

				</tr>

				<tr id="ins_aft_row">
					<td class="leftd">Insert After</td>
					<td>
					<select id="ins_aft">
						<option id="123" value="123">&nbsp&nbsp</option>
						<?php
						$result = mysql_query("select name,position from neutron.firewall_rules order by position",$con2);
						while ($row = mysql_fetch_array($result)) {
							echo "<option id='" . $row[1] . "' value= '" . $row[1] . "'>$row[0]</option>";

						}
						?>
					</select></td>
					<td></td>

				</tr>

				<tr>
					<td  class="leftd">Action*</td><td>
					<input type="radio" name='actn' id='allow' value="allow" checked="checked">
					Allow</input>
					<input type="radio" name='actn' id='deny' value="deny">
					Deny</input> </td><td></td>
				</tr>

			</table>
			<div align="center">
				<input type="submit" value="OK"/>
				<input type="button" value="Cancel" onclick='firewallsql()'/>
				<input type='hidden' id='org_rule_nm' value=''/>
				<input type='hidden' id='rule_id' value=''/>
			</div>

		</form>
	</body>
</html>
