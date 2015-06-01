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


cd ~
curl -L -O http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.8.tar.gz
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
cd ~
curl -L -O http://nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz
tar xvf nagios-plugins-2.0.3.tar.gz
cd nagios-plugins-2.0.3
./configure --with-nagios-user=nagios --with-nagios-group=nagcmd --with-openssl
make
make install

#Configure Nagios
cp /opt/naanal/manager/conf/nagios/nagios.cfg /usr/local/nagios/etc/nagios.cfg
mkdir /usr/local/nagios/etc/servers
cp /opt/naanal/manager/conf/nagios/openstack.cfg /usr/local/nagios/etc/servers/
cp /opt/naanal/manager/conf/nagios/contacts.cfg /usr/local/nagios/etc/objects/
cp /opt/naanal/manager/conf/nagios/commands.cfg /usr/local/nagios/etc/objects/



#Configure-Apache
a2enmod rewrite
a2enmod cgi
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/

ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios

###NDO2DB###
apt-get -y install mysql-client libmysqlclient-dev

cd ~
wget http://sourceforge.net/projects/nagios/files/ndoutils-2.x/ndoutils-2.0.0/ndoutils-2.0.0.tar.gz
tar -zxvf ndoutils-2.0.0.tar.gz
cd ndoutils-2.0.0/
./configure --prefix=/usr/local/nagios/ --enable-mysql --with-ndo2db-user=nagios --with-ndo2db-group=nagcmd
make
make install
db/installdb -u root -p password -d nagios
cp /opt/naanal/manager/conf/nagios/ndo2db.cfg /usr/local/nagios/etc/
cp /opt/naanal/manager/conf/nagios/ndomod.cfg /usr/local/nagios/etc/
chown nagios:nagcmd /usr/local/nagios/etc/ndo*
chmod 775 /usr/local/nagios/etc/ndo*
cp daemon-init /etc/init.d/ndo2db
chmod +x /etc/init.d/ndo2db
chmod 777 /usr/local/nagios/var/rw/nagios.*
update-rc.d ndo2db defaults


###NRPE-PLUGIN###
cd ~
wget http://sourceforge.net/projects/nagios/files/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz
tar xfvz nrpe-2.15.tar.gz
cd nrpe-2.15/
./configure --with-ssl=/usr/bin/openssl --with-ssl-lib=/usr/lib/x86_64-linux-gnu/ --with-nrpe-group=nagcmd --with-nagios-group=nagcmd
make all
make install-plugin



/etc/init.d/apache2 restart
/etc/init.d/ndo2db start
/etc/init.d/nagios start
