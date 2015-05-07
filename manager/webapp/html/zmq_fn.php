<?php

require 'loginproc.php';
$ip = $_SESSION['squid_ip'];
/* Server hostname */
//$ip = '192.168.248.148';
$dsn = "tcp://$ip:5555";

function zmq_exec($cmd) {
	global $dsn;
	/* Create a socket */
	$socket = new ZMQSocket(new ZMQContext(), ZMQ::SOCKET_REQ, 'my socket');
	$socket -> connect($dsn);
	$socket -> send(json_encode($cmd));
	$message = $socket -> recv();
	$msg = explode("\n", rtrim($message));
	return $msg;
}

/* Get list of connected endpoints */
//$endpoints = $socket -> getEndpoints();

/* Check if the socket is connected */
//if (!in_array($dsn, $endpoints['connect'])) {
//	echo "<p>Connecting to $dsn</p>";
//	$socket -> connect($dsn);
//} else {
//	echo "<p>Already connected to $dsn</p>";
//}

/* Send and receive */
//$socket -> send("Hello!");

/*$qu = " df -h -BG --total | grep 'total' | awk '{print $2}' && nproc | awk '{print $0*7.5}' && vmstat -s  | grep 'total memory' | awk '{print $1/1000}'";

 $arr1 = array('fn' => 'shell', 'cmd' => $qu);

 $arr2 = array('fn' => 'shut', 'subfn' => 'shutdown');

 $msg = zmq_exec($arr1);

 foreach ($msg as $val) {

 echo "<p>Server said: $val</p>";
 }

 $msg = zmq_exec($arr2);

 foreach ($msg as $val) {

 echo "<p>Server said: $val</p>";
 }
 */
?>
