#Murano Dashboard Installation over existing Dashboard

DASHBOARD_DIR=/opt/naanal/webapp
MURANO_DASHBORD_DIR=/home/naanal/murano-dashboard

git clone http://github.com/openstack/murano-dashboard.git $MURANO_DASHBORD_DIR

pushd $MURANO_DASHBORD_DIR

$DASHBOARD_DIR/tools/with_venv.sh pip install .

cp muranodashboard/local/_50_murano.py $DASHBOARD_DIR/openstack_dashboard/enabled/

popd

