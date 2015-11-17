1.Create custom_setting table :
	
	use naanal;
	CREATE TABLE `custom_setting` (`id` int(11) NOT NULL AUTO_INCREMENT,`instance` char(50) NOT NULL DEFAULT '', `autostart` tinyint(1) DEFAULT NULL,PRIMARY KEY (`id`,`instance`)) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

2.Change OS_IP in variables.py to Openstack's IP and move it to /usr/lib/python2.7/

3.move autostart.py to rc.local [I didn't tested it]

4.Add this to visudo 
	www-data ALL=(ALL) NOPASSWD: ALL

5.chmod to files