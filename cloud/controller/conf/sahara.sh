sahara_dir=/home/naanal/sahara-venv
TENANT_ID=

apt-get -y install python-setuptools python-virtualenv python-dev python-pip python-vrtualenv

cd /home/naanal
virtualenv sahara-venv
cd $sahara_dir
source $sahara_dir/bin/activate
pip install mysql-python
pip install http://tarballs.openstack.org/sahara/sahara-master.tar.gz

mkdir $sahara_dir/etc
#cp sahara-venv/share/sahara/sahara.conf.sample-basic sahara-venv/etc/sahara.conf

cp /opt/naanal/controller/conf/sahara.conf $sahara_dir/etc/sahara.conf
cp /opt/naanal/controller/conf/sahara_template $sahara_dir/
cp /opt/naanal/controller/conf/policy.json $sahara_dir/etc/
cp /opt/naanal/controller/conf/start_sahara.sh $sahara_dir/start_sahara.sh

mysql -u root -ppassword<<EOF
DROP DATABASE IF EXISTS sahara;
CREATE DATABASE sahara;
GRANT ALL PRIVILEGES ON sahara.* TO 'sahara'@'localhost' IDENTIFIED BY 'SAHARA_DBPASS';
GRANT ALL PRIVILEGES ON sahara.* TO 'sahara'@'%' IDENTIFIED BY 'SAHARA_DBPASS';
EOF


source /opt/naanal/controller/conf/admin-openrc.sh


openstack user create --password SAHARA_PASS sahara
openstack role add --project service --user sahara admin


openstack service create --name sahara --description="Sahara Data Processing" data-processing

openstack endpoint create --publicurl="http://controller:8386/v1.1/%(tenant_id)s"  --internalurl="http://controller:8386/v1.1/%(tenant_id)s" --adminurl="http://controller:8386/v1.1/%(tenant_id)s" --region RegionOne data-processing


$sahara_dir/bin/sahara-db-manage --config-file $sahara_dir/etc/sahara.conf upgrade head

sahara-templates --config-file $sahara_dir/etc/sahara.conf --config-file $sahara_dir/sahara_template update -t $TENANT_ID


$sahara_dir/bin/python $sahara_dir/bin/sahara-all --help

$sahara_dir/start_sahara.sh


cd /home/naanal
git clone https://github.com/openstack/sahara-image-elements
cd sahara-image-elements
tox -e venv -- sahara-image-create -p vanilla -i ubuntu -v 2.7.1

glance image-create --name "sahara_vanilla_ubuntu_2.7.1" --file ubuntu_sahara_vanilla_hadoop_2_7_1_latest.qcow2 --disk-format qcow2 --container-format bare --visibility public --progress



