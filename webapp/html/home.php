<html>
	<head>
		<?php
		include 'arrays.inc';

		require ("loginproc.php");
		require ("blockuser.php");
		?>
		<title>Naanal Technologies</title>
		<script language="javascript" src="home.js"></script>
		<script language="javascript" src="vdi.js"></script>
		<script src="js/jquery.js" ></script>
		<script src="js/Chart.js" ></script>
		<script src="js/jquery-ui-1.11.1/jquery-ui.js"></script>

		<script>
			$(document).ready(function() {
				$('#OVERVIEW').css({

					'color' : '#02d6fc',
					'background' : '#666666'

				});

				$('.leftnav-anc').click(function(e) {
					//e.preventDefault();
					// prevent default anchor behav.
					$('.leftnav-anc').css({
						'color' : 'white',
						'background' : 'linear-gradient(to bottom,  rgba(127,127,127,1) 5%,rgba(110,110,110,1) 25%,rgba(53,53,53,0.93) 93%,rgba(53,53,53,0.92) 10%)' /* W3C */

					});

					$(this).css({

						'color' : '#02d6fc',
						'background' : '#666666'

					});
				});

			});

		</script>
		<link rel="stylesheet" href="js/jquery-ui-1.11.1/jquery-ui.css">
		<link rel="stylesheet" href="js/jquery-ui-1.11.1/jquery-ui.theme.css"/>
		<link rel="stylesheet" href="js/jquery-ui-1.11.1/jquery-ui.structure.css"/>
		<link rel="stylesheet" href="home.css"/>
	</head>
	<body onload="overviewsql()" >
		<div>
			<div class="home" id="leftnav">
				<?php
				foreach ($leftnav as $val) {
					$fn = str_replace(" ", "", $val);
					$fn = strtolower($fn);
					$fn = $fn . "sql()";
					#<a href="#" class="leftnav-anc" onclick=timeaccesscontrol() >TIME ACCESS CONTROL</a>
					#echo ' <div  class="nav-button"> <img class="img_icons" src="images/' . $val . '.ico"  > '."<a href=\"#\" class=\"leftnav-anc\" onclick= '$fn' > $val  </a> ";
					echo '<li  > <a href="javascript:' . $fn . '"  class="leftnav-anc nav-button" id= ' . $val . '><img class="img_icons" src="images/' . $val . '.ico"  > ' . $val . '</a></li>';
				}
				?>
				</div>
				<div id="header" class="home"><img class="home" id="logo" src="naanal.png"/>
					<a href="#" id="logoutText" onclick="location.href='logout.php'">Logout</a>
					<input type="image" id="logout" src="logout.ico" onclick="location.href='logout.php'"/>
					<div id="welcome">
						<?php $welcome = "Welcome " . ucfirst($_SESSION['name']);
						echo $welcome;
						?>
					</div>

					<div id="topnav"></div>
				</div>

				<div id="table"></div>
				<div>
					<input type="hidden" id="ins_limit" value=<?php echo "'$ins_limit'"; ?> />
					<input type="hidden" id="ins_offset" value=0 />
					<input type="hidden" id="instance_int" />
				</div>
				<div id="dialog-confirm" title="Delete Items">
					<p>
						<span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>These items will be permanently deleted and cannot be recovered. Are you sure?
					</p>
				</div>

				<div id="snapshot" title="Snapshot">
					<p id="snapshot_table">

					</p>
					<div id="host" title="Please Make sure no one is using any Instance">
						<p id="host_table">

						</p>

					</div>

					<div id="footer">

						© Naanal Technologies
					</div>

				</div>
	</body>
</html>
