###NRPE SERVER###
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
apt-get -y install nagios-plugins nagios-nrpe-server
