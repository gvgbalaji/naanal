<html>
	<head>
		<?php
		require 'loginproc.php';
		include 'arrays.inc';
		include 'zmq_fn.php';

		//exec(" df -h -BG --total | grep 'total' | awk '{print $2}' && nproc | awk '{print $0*$core_multiplier}' && vmstat -s  | grep 'total memory' | awk '{print $1/1000}'", $out, $res);

		$cmd = " df -h -BG --total | grep 'total' | awk '{print $2}' && nproc | awk '{print $0*7.5}' && vmstat -s  | grep 'total memory' | awk '{print $1/1000}'";
		$arr1 = array('fn' => 'shell', 'cmd' => $cmd);
		$out = zmq_exec($arr1);

		$num_rows = mysql_result(mysql_query("select count(*) from nova.instances where deleted=0 and vm_state!='deleted'", $con2), 0);

		$total_pages = ceil($num_rows / $vm_limit);
		?>
	</head>
	<body >
		<div id="vdi_summary" >
			<div id="vdi_system_status" class="summarydiv">
				<table  class="tb1" id="tb1">
					<caption>
						System Status
					</caption>
					<tr>
						<td>System Time</td>
						<td ><p id="dt" ></p></td>
					</tr>
					<tr>
						<td>Started At</td><td><p id="st" ></p></td>
					</tr>
					<tr>
						<td>Up Time</td><td><p id="ut" ></p></td>
					</tr>
					<tr>
						<td>Active Instances/Total Instances</td><td><p id="ins" ></p></td>
					</tr>
					<tr>
						<td>Allocated cores/Total Cores</td><td ><label id="core"></label> / <label id='core1'><?php echo $out[1]; ?></label></td>
					</tr>
					<tr>
						<td>Allocated Memory/Total Memory</td><td><label id="mem" ></label> / <label id='mem1'><?php echo round($out[2]); ?></label> (MB)</td>
					</tr>
					<tr>
						<td>Active Disk/Total Disk</td><td><label id="disk" ></label> / <label id='disk1'><?php echo str_replace("G", "", $out[0]); ?></label> (GB)</td>
					</tr>

				</table>

			</div>

				<table  class="tb0">
					<caption >
						CPU (%)
					</caption>
					<tr>
						<td>
						<canvas id="vdi_cpuusage"  height=200px width=400px />
						</td>
					</tr>
				</table>
				<table  class="tb0">
					<caption >
						Memory (%)
					</caption>
					<tr>
						<td>
						<canvas id="vdi_memoryusage"  height=200px width=400px />
						</td>
					</tr>
				</table>
				<table class="tb0">
						<tr><th>Instances (Active vs Shutdown)</th><th>Cores</th><th>Memory(MB)</th><th>Disk(GB)</th></tr>
					
					<tr id="vdi_charts_tr">
						<td >
							<canvas id="instance_chart" height=150px width=250px />
						</td>
						<td >
							<canvas id="core_chart" height=150px width=250px />
						</td>
						<td >
							<canvas id="mem_chart" height=150px width=250px />
						</td>
						<td >
							<canvas id="disk_chart" height=150px width=250px />
						</td>
					</tr>

				</table>
				<table  class="tb0">
					<caption >
						TOP VMs CPU (%)
					</caption>
					<tr>
						<td>
						<canvas id="vdi_vmusage"  height=200px width=400px />
						</td>
					</tr>
				</table>
				<table  class="tb0">
					<caption >
						ALL VMs CPU (%)
					</caption>
					
					<tr>
						<td class='leftd'><input type="button" onclick="next_prev('prev')" class="len_button" value="<" /></td>
						<td class='midtd'>
						<canvas id="vdi_all_vmusage"  height=200px width=400px />
						</td>
						<td class='rightd'><input type="button" onclick="next_prev('next')" class="len_button" value=">" /></td>
					</tr>
				</table>
				<div>
					<input type="hidden" id="vm_limit" value=<?php echo "'$vm_limit'"; ?> />
					<input type="hidden" id="vm_offset" value=0 />
					<input type="hidden" id="vm_tot_pages" value= <?php echo "'$total_pages'"; ?> />
					<input type="hidden" id="vm_curr_page" value=1 />
					
				</div>
	</body>
</html>