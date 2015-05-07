<?php
  //$hostname = '192.168.1.230';        // Your MySQL hostname. Usualy named as 'localhost', so you're NOT necessary to change this even this script has already online on the internet.
$hostname = '192.168.1.230';
$dbname   = 'naanal'; // Your database name.
$username = 'root';             // Your database username.
$password = 'password';                 // Your database password. If your database has no password, leave it empty.


// Let's connect to host

$con2 = mysql_connect($hostname, "root", "password") or DIE('Connection to host is failed, perhaps the service is down!');

//$con2 = mysql_connect("192.168.1.230", "root", "password") or DIE('Connection to host is failed, perhaps the service is down!');


$con=mysql_connect($hostname, $username, $password) or DIE('Connection to host is failed, perhaps the service is down');
// Select the database
mysql_select_db($dbname) or DIE('Database name is not available!');


?>
