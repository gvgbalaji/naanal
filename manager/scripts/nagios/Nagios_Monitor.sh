###NAGIOS-4###
apt-get update
apt-get -y install build-essential libgd2-xpm-dev openssl libssl-dev apache2-utils

#adding swap(This might take some time)

dd if=/dev/zero of=/swap bs=1024 count=2097152
mkswap /swap && sudo chown root. /swap && sudo chmod 0600 /swap && sudo swapon /swap
/swap swap swap defaults 0 0 >> /etc/fstab"
vm.swappiness = 0 >> /etc/sysctl.conf && sysctl -p"


useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios

tar xvf nagios-4.0.8.tar.gz
cd nagios-4.0.8
./configure --with-nagios-group=nagios --with-command-group=nagcmd

make all
make install
make install-commandmode
make install-init
make install-config
/usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf

#Nagios-Plugins
cd ..
tar xvf nagios-plugins-2.0.3.tar.gz
cd nagios-plugins-2.0.3
./configure --with-nagios-user=nagios --with-nagios-group=nagcmd --with-openssl
make
make install

#Configure Nagios
cp /opt/naanal/manager/scripts/nagios/conf/nagios.cfg /usr/local/nagios/etc/nagios.cfg
cp /opt/naanal/manager/scripts/nagios/conf/localhost.cfg /usr/local/nagios/etc/objects/
mkdir /usr/local/nagios/etc/servers
cp /opt/naanal/manager/scripts/nagios/conf/controller.cfg /usr/local/nagios/etc/servers/
cp /opt/naanal/manager/scripts/nagios/conf/win_hostgroup.cfg /usr/local/nagios/etc/servers/
cp /opt/naanal/manager/scripts/nagios/conf/contacts.cfg /usr/local/nagios/etc/objects/
cp /opt/naanal/manager/scripts/nagios/conf/commands.cfg /usr/local/nagios/etc/objects/

cp  /opt/naanal/manager/scripts/nagios/plugins/localhost/* /usr/local/nagios/libexec/

#Configure-Apache
a2enmod rewrite
a2enmod cgi
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/

ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios

###NDO2DB###
apt-get -y install mysql-client libmysqlclient-dev

cd ..
tar -zxvf ndoutils-2.0.0.tar.gz
cd ndoutils-2.0.0/
./configure --prefix=/usr/local/nagios/ --enable-mysql --with-ndo2db-user=nagios --with-ndo2db-group=nagcmd
make
make install
db/installdb -u root -p password -d nagios
cp /opt/naanal/manager/scripts/nagios/conf/ndo2db.cfg /usr/local/nagios/etc/
cp /opt/naanal/manager/scripts/nagios/conf/ndomod.cfg /usr/local/nagios/etc/
chown nagios:nagcmd /usr/local/nagios/etc/ndo*
chmod 775 /usr/local/nagios/etc/ndo*
cp daemon-init /etc/init.d/ndo2db
chmod +x /etc/init.d/ndo2db
chmod 777 /usr/local/nagios/var/rw/nagios.*
update-rc.d ndo2db defaults

###NRPE-PLUGIN###
cd ..
tar -zxvf nrpe-2.15.tar.gz
cd nrpe-2.15/
./configure --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu/ --with-nrpe-group=nagcmd --with-nagios-group=nagcmd
make all
make install-plugin

###Remote Installation On Controller###
sshpass -p "password" scp /opt/naanal/manager/scripts/nagios/nrpe.sh  root@192.168.1.230:/opt/naanal/controller/scripts/

sshpass -p 'password' ssh -o StrictHostKeyChecking=no root@192.168.1.230 '/bin/bash /opt/naanal/controller/scripts/nrpe.sh'

sshpass -p "password" scp /opt/naanal/manager/scripts/nagios/plugins/controller/*  root@192.168.1.230:/usr/lib/nagios/plugins/

sshpass -p "password" scp /opt/naanal/manager/conf/nrpe/nrpe.cfg  root@192.168.1.230:/etc/nagios/nrpe.cfg

sshpass -p 'password' ssh -o StrictHostKeyChecking=no root@192.168.1.230 'service nagios-nrpe-server restart'



/etc/init.d/apache2 restart
/etc/init.d/ndo2db start
/etc/init.d/nagios start
