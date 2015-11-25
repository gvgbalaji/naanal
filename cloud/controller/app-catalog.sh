DASHBOARD_DIR=/opt/naanal/webapp
APP_CAT_DIR=/home/naanal/app-catalog-ui

git clone http://github.com/openstack/app-catalog-ui.git $APP_CAT_DIR

cd $DASHBOARD_DIR 

./run_tests.sh -f --docs

pushd $APP_CAT_DIR

$DASHBOARD_DIR/tools/with_venv.sh pip install .

cp  app_catalog/enabled/* $DASHBOARD_DIR/openstack_dashboard/enabled/

popd
