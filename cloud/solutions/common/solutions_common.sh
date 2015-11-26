start_time=`date +%s`

ops_ip=192.168.1.30
ops_net=192.168.1.0
ops_mask=255.255.255.0
src_dir=/opt/naanal/cloud/solutions/
target_dir=/opt/naanal/webapp


echo "Installing dependent packages.."

apt-get install -y python-pip python-dev libmysqlclient-dev libpq-dev libxml2-dev libxslt1-dev libffi-dev

cd /opt/naanal/
cp $src_dir/common/dl/horizon_kilo.gz .
tar -zxvf horizon_kilo.gz
mv horizon webapp

cd $target_dir

#------------------------------------------------------------------------#

## Horizon ##
#echo "Installing Horizon"
#apt-get install -y openstack-dashboard

echo "Configuring Horizon dashboard"

#apt-get remove -y --purge openstack-dashboard-ubuntu-theme


cp $src_dir/common/admin/conf/local_settings.py $target_dir/openstack_dashboard/local/
cp $src_dir/common/admin/img/favicon.ico $target_dir/openstack_dashboard/static/dashboard/img/
cp $src_dir/common/admin/img/logo-splash.png $target_dir/openstack_dashboard/static/dashboard/img/
cp $src_dir/common/admin/img/logo.png $target_dir/openstack_dashboard/static/dashboard/img/

cp -rf $src_dir/common/admin/dashboards/* $target_dir/openstack_dashboard/dashboards/
cp -rf $src_dir/common/admin/enabled/* $target_dir/openstack_dashboard/enabled/
cp $src_dir/common/admin/patches/openstack_dashboard.usage.tables.py $target_dir/openstack_dashboard/usage/tables.py

#service apache2 reload
#./run_tests.sh --runserver 192.168.1.30:3000

echo "Horizon Finished"


#------------------------------------------------------------------------#

