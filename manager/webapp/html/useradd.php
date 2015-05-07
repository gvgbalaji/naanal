<html>
	<head>
		<?php
		include 'arrays.inc';
		require 'loginproc.php';
		?>
	</head>
	<body>
		<form id="groupform" action="javascript:userssql('add')" >
			<table id="tblband">
				<caption id="pol">
					Add Users
				</caption>
				<tr>
					<td>&nbsp;</td><td>&nbsp;</td>
				</tr>
				<tr>
					<td class="leftd">Full Name:</td><td>
					<input type='text' class="text"  name="usr_nm" id="usr_nm" placeholder="Enter Full Name" required="required"/>
					</td>
				</tr>

				<tr>
					<td class="leftd">Login Name:</td><td>
					<input type='text' class="text" name='login_nm' id="login_nm" placeholder="Enter Login name" required="required"/>
					</td>
				</tr>

				<tr>
					<td class="leftd">Password:</td><td>
					<input type='password' id='passwd' name='passwd' class="text" placeholder='Password' required="required"/>
					<img class='set' id="edit_passwd" src='settings.png' /></td>
				</tr>
				<tr>
					<td class="leftd">User Type:</td><td>
					<input type='radio' name='usr_type' class="usr_type" id="User" value='User' checked>
					User</input>
					<input type='radio' name='usr_type' class="usr_type" id="Admin" value='Admin' >
					Admin</input></td>
				</tr>

				<tr id="ins_tr">
					<td class="leftd">Group:</td><td>
					<select name="ins_nm" id="ins_nm">
						<?php
						$query = "select display_name from nova.instances where vm_state!='deleted' and deleted=0 ";
						$result = mysql_query($query, $con2);
						while ($row = mysql_fetch_array($result)) {
							echo "<option id='" . $row[0] . "' value='" . $row[0] . "'>$row[0]</option>";

						}
						?>
					</select></td>
				</tr>
				<tr>
					<td>&nbsp;</td><td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td><td>
					<input type="submit" value="OK" class="addel-button"/>
					<input type="button" value="CANCEL" onclick='userssql()' class="addel-button"/>
					</td>
				</tr>
				<input type="hidden" value="" id="usr_org_pass" />
			</table>

		</form>
	</body>
</html>
