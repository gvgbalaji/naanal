<?php
$hostname = 'localhost';
$dbname   = 'naanal'; // Your database name.
$username = 'root';             // Your database username.
$password = 'password';                 // Your database password. If your database has no password, leave it empty.


// Let's connect to host


$con2 = mysql_connect($_SESSION['squid_ip'], "root", "password");
//$con2 = mysql_connect($_SESSION['squid_ip'], "root", "password") or DIE('Connection to host is failed, perhaps the service is down!');
$con=mysql_connect($hostname, $username, $password) or DIE('Connection to host is failed, perhaps the service is down');
// Select the database
mysql_select_db($dbname) or DIE('Database name is not available!');


?>
