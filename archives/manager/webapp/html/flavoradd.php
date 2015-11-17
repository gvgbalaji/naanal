<html>
	<head>
		<?php
		include 'arrays.inc';
		require 'loginproc.php';
		?>
	</head>
	<body>
		<form id="flavorform" action="javascript:flavorssql('add')">

			<table id="tblband">
				<caption id="pol">
					Add Flavors
				</caption>
				<tr>
					<td class="leftd">ID:</td><td>
					<input type="number" class="group1" id="flv_id" name="flv_id" required="required" min="1"  />
					</td>
				</tr>

				<tr>
					<td class="leftd">Flavor Name:</td><td>
					<input type="text" class="group1" id="flv_nm" name="flv_nm" required="required" pattern="[a-zA-Z0-9_.]+" title="Alphanumeric,Underscore and period only allowed" maxlength="25"/>
					</td>
				</tr>

				<tr>
					<td class="leftd">RAM</td><td>
					<input type="number" id='ram' min="128" required="required"/>
					&nbsp;(MB) </td>
				</tr>
				<tr>
					<td class="leftd">Disk</td><td>
					<input type="number" id='disk' min="1" required="required"/>
					&nbsp;(GB) </td>
				</tr>
				<tr>
					<td class="leftd">VCPU</td><td>
					<input type="number" id='vcpu' min="1" required="required"/>
					&nbsp;(Cores) </td>
				</tr>
				<tr>
					<td>&nbsp;</td><td>&nbsp;</td>
				</tr>
				<tr>
					<td class="leftd"></td>
					<td>
					<input type="submit" value="OK"  id="add_button" class="addel-button"/>
					<input type="button" value="CANCEL" onclick='flavorssql()' class="addel-button"/>
					</td>
				</tr>
			</table>
			</div>

		</form>
	</body>
</html>
