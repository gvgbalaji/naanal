<?php

// Inialize session
session_start();

// Check, if user is already login, then jump to secured page
if (isset($_SESSION['username']) && $_SESSION['admin_flag'] == 1) {

	header('Location: home.php');

} elseif (isset($_SESSION['username']) && $_SESSION['admin_flag'] == 0) {

	header('Location: user.php');

}
?>
<html>

	<head>
		<title>Naanal Controller Application</title>
		<style>
			body {
				background-image: url("login1.jpg");
				opacity: 0.85;
			}
			#loginScreen {
				margin-left: 40%;
				border: 3px solid #4096ee;
				background: rgb(212,228,239); /* Old browsers */
				background: -moz-linear-gradient(top,  rgba(212,228,239,1) 0%, rgba(134,174,204,1) 100%); /* FF3.6+ */
				background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(212,228,239,1)), color-stop(100%,rgba(134,174,204,1))); /* Chrome,Safari4+ */
				background: -webkit-linear-gradient(top,  rgba(212,228,239,1) 0%,rgba(134,174,204,1) 100%); /* Chrome10+,Safari5.1+ */
				background: -o-linear-gradient(top,  rgba(212,228,239,1) 0%,rgba(134,174,204,1) 100%); /* Opera 11.10+ */
				background: -ms-linear-gradient(top,  rgba(212,228,239,1) 0%,rgba(134,174,204,1) 100%); /* IE10+ */
				background: linear-gradient(to bottom,  rgba(212,228,239,1) 0%,rgba(134,174,204,1) 100%); /* W3C */
				filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#d4e4ef', endColorstr='#86aecc',GradientType=0 ); /* IE6-9 */
				-webkit-box-shadow: 24px 22px 23px 20px rgba(0,0,0,0.75);
				-moz-box-shadow: 24px 22px 23px 20px rgba(0,0,0,0.75);
				box-shadow: 24px 22px 23px 20px rgba(0,0,0,0.75);
			}

			.img_icons {

				margin-left: 45%;
				margin-top: 15%;
				margin-bottom: 10px;
				width: 90px;
				height: 40px;
			}
		</style>

	</head>

	<body>

		<table id="loginScreen" border="0">
			<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			<form method="POST" action="loginproc.php">
				<tr><img class="img_icons" src="naanal.png" >
				</tr>
				<tr>
					<td>&nbsp;</td><td><b>Username: </b></td><td>
					<input type="text" name="username" size="30">
					</td><td>&nbsp;</td>
				</tr>
				<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
				<tr>
					<td>&nbsp;</td><td><b>Password: </b></td><td>
					<input type="password" name="password" size="30">
					</td><td>&nbsp;</td>
				</tr>

				<tr>
					<td>&nbsp;</td><td>&nbsp;</td>
				<tr>
					<td>&nbsp;</td><td>&nbsp;</td><td>
					<input type="submit" value="Login">
					</td>
				</tr>
				<tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr><tr></tr>
			</form>
		</table>

	</body>

</html>
