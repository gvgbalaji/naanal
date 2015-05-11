<html>
	<head>
		<?php
		include 'arrays.inc';
		require 'loginproc.php';

		$q = "select * from initial_configuration order by editable asc";
		$result = mysql_query($q, $con2);
		$enable = array("disabled", "");
		?>
	</head>
	<body>
		<form id="configform" action="javascript:configsql('add')">

			<table id="tblband">
				<caption id="pol">
					Add Configuration Details
				</caption>
				<?php
				while ($row = mysql_fetch_array($result)) {
					$ed = $enable[$row[3]];
					echo "<tr><td class='leftd'>$row[0]:</td><td><input type='text' class='group1' id='$row[1]'  required='required' value='$row[2]' $ed /></td></tr>";

				}
				?>

				<tr>
					<td class="leftd"></td>
					<td>
					<input type="submit" value="OK"  id="add_button" class="addel-button"/>
					<input type="button" value="CANCEL" onclick='configsql()' class="addel-button"/>
					</td>
				</tr>

			</table>
			</div>

		</form>
	</body>
</html>
