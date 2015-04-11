<html>
	<head></head>
	<body>

		<table id="tblband">
			<caption id="pol">
				Add Image
			</caption>
			<tr>
				<td class="leftd">Image Name:</td><td>
				<input type="text"  id = "img_nm" name="img_nm" required="required"/>
				</td>
			</tr>
			<tr>
				<td class="leftd">Format:</td>
				<td>
				<select id ="df" >

					<option id="iso" value="iso">ISO</option>
					<option id="vmdk" value="vmdk">VMDK</option>
					<option id="qcow2" value="qcow2">QCOW2/IMG</option>

				</select></td>

			</tr>
			<tr>
				<td class="leftd">Image File:</td>
				<td>
				<form action="upload_back.php" method="post" enctype="multipart/form-data" id="upload_form">
					<input type="file" name="file1" id="file1">
					<input type="submit" name="submit" id="submit" value="upload">
					<input type="button" value="Abort" id = "abort" />
				</form></td>
			<tr>
				<td></td>
				<td>
				<div style="width:400px;">
					<div id="progressbar">
						<div id="progress" style="width:0px;"></div>
					</div>
				</div></td>
			</tr>
			<tr>
				<td></td><td><div id="status"></div></td>

				</td>
			</tr>

			<tr>
				<td></td><td>
				<input type='button'  value='OK' onclick="imagessql('add')" id="ok" disabled="disabled" />
				&nbsp
				<input type='button'  value='Cancel' id="cancel"/>
				</td>
			</tr>
		</table>
		
	</body>
</html>