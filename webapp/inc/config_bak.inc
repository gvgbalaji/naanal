<?php
  $hostname = 'localhost';        // Your MySQL hostname. Usualy named as 'localhost', so you're NOT necessary to change this even this script has already online on the internet.
//$dbname   = 'naanal'; // Your database name.
$username = 'root';             // Your database username.
$password = 'password';                 // Your database password. If your database has no password, leave it empty.


// Let's connect to host

$con=mysql_connect($hostname, $username, $password) or DIE('Connection to host is failed, perhaps the service is down!');
?>
