<html>
	<head>
		<?php
		require 'loginproc.php';
		include 'arrays.inc';
		?>
	</head>
	<body >
		<div class="container">
			<table data-ss-colspan='2' class="in_tbl">
				<caption>
					Controller Node
				</caption>

				<tr>
					<th>Parameter</th><th>Value</th>
				</tr>
				<tr>
					<td>Status</td><td id='host_status'></td>
				</tr>
				<tr>
					<td>Server UP Duration</td><td id='host_up_duration'></td>
				</tr>
				<tr>
					<td>CPU Usage</td><td id='host_cpu'></td>
				</tr>
				<tr>
					<td>RAM Usage</td><td id='host_ram'></td>
				</tr>
				<tr>
					<td>Free Disk Space</td><td id='host_disk'></td>
				</tr>
			</table>

			<table data-ss-colspan='3' >
				<caption>
					Controller Utilization
				</caption>
				<tr>
					<td><div id="chart"></div></td>
				</tr>
			</table>

			<table  data-ss-colspan='2' class="in_tbl" >
				<caption>
					VM Statistics
				</caption>
				<tr>
					<th>Parameter</th><th>Value</th>
				</tr>

				<tr>
					<td>No. of VMs (Running/Stopped)</td><td id='vm_num'></td>
				</tr>
				<tr>
					<td>No. of VMs with CPU Utilization > 80%</td><td id='vm_cpu'></td>
				</tr>
				<tr>
					<td>No. of VMs with RAM Utilization >80%</td><td id='vm_ram'></td>
				</tr>
				<tr>
					<td>No. of VMs with Disk(C:\) < 4GB</td><td id='vm_disk'></td>
				</tr>
				<tr>
					<td>No. of VMs with Possible Network Issue</td><td id='vm_net'></td>
				</tr>

			</table>
			<table data-ss-colspan="3">
				<caption>
					VM Utilization
				</caption>
				<tr>
					<td><div id="chart2"></div></td>
				</tr>
			</table>

			<table id="stopped_vm" data-ss-colspan="1">
				<caption>
					Stopped VMs
				</caption>

			</table>

			<table id="high_ram" data-ss-colspan="1">
				<caption>
					High RAM Usage
				</caption>

			</table>

			<table id="high_cpu" data-ss-colspan="1">
				<caption>
					High CPU Usage
				</caption>

			</table>

			<table id="low_disk" data-ss-colspan="1">
				<caption>
					Low Disk Space
				</caption>

			</table>
		</div>

	</body>
</html>