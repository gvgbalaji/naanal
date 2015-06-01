###NRPE SERVER###
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
apt-get -y install nagios-plugins nagios-nrpe-server
sshpass -p "password" scp /opt/naanal/manager/conf/nrpe/nrpe.cfg  root@192.168.1.230:/etc/nagios/nrpe.cfg