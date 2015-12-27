#!/usr/bin/python
controller_ip="192.168.30.168"
target_host = "naanal-laptop1"
#lan_net = "55f220d8-f0ce-402c-b510-6795c85f2675"


import time
import MySQLdb

from novaclient import client as nova_client
from cinderclient import client as cinder_client
nova = nova_client.Client(2,"admin","ADMIN","admin","http://%s:5000/v2.0"%controller_ip)
cinder = cinder_client.Client(1,"admin","ADMIN","admin","http://%s:5000/v2.0"%controller_ip)

con = MySQLdb.connect(controller_ip,"root","password")

### Host Functions ###

def down_hosts():
    return [host for host in nova.services.list(binary="nova-compute") if host.state == 'down']

def active_hosts():
    return [host for host in nova.services.list(binary="nova-compute") if host.state == 'up']

def host_delete(host_obj):
    nova.services.delete(host_obj[0].id)

### Instance Functions ###
    
def list_instances(host_name):
    ins_list = nova.servers.list(search_opts={'host':host_name})
    return ins_list    

def parse_inst_details(instance_obj):
    info = instance_obj._info
    inst_id = info.get('id')
    name = info.get('name')
    image_id = info.get('image')['id']
    flavor_id = info.get('flavor')['id']
    key_name = info.get('key_name')
    fixed_ip = info.get('addresses')['lan-net'][0]['addr']
    flt_ip = info.get('addresses')['lan-net'][1]['addr']
    volume_id = info.get('os-extended-volumes:volumes_attached')[0]['id']
    return dict([(key,str(eval(key))) for key in ('name','image_id','flavor_id','key_name','fixed_ip','volume_id','inst_id','flt_ip')])


def create_instance_mysql(name,volume_id,flt_ip):
    # By using similiar Naming Pattern We should fetch and Turn on Standby Instance(it's uuid is unknown) Eg:(Active: test; Standby: test-ha)
    name = name + '-ha'
    uuid_q = "select uuid nova.instances where display_name='{0}' and host='{1}';".format(name,target_host)
    print(uuid_q+"\n")
    uuid_cur = con.cursor()
    uuid_cur.execute(uuid_q)
    uuid = uuid_cur.fetchone()

    undelete_q = "update nova.instances set deleted=0 where uuid='{0}';".format(uuid)
    print(undelete_q+"\n")
    #undelete_cur = con.cursor()
    #undelete_cur.execute(undelete_q)

    tmp_ins_obj = nova.servers.get(uuid)
    print tmp_ins_obj.name
    #flt_ip_attach(tmp_ins_obj,flt_ip)
    #volume_attach(volume_id,uuid)
    #tmp_ins_obj.start()


def delete_instance_mysql(uuid,volume_id,host_name):
    #volume_detach(volume_id)
    
    tmp_ins_obj = nova.servers.get(uuid)
    print tmp_ins_obj.name
    #flt_ip_detach(tmp_ins_obj,flt_ip)
    
    delete_q = "update nova.instances set deleted=1 where uuid='{0}' and  host = '{1}';".format(uuid,host_name)
    print(delete_q+"\n")
    #delete_cur = con.cursor()
    #delete_cur.execute(delete_q)
    
    



### Cinder Functions ###
    
def volume_detach(volume_id):
    cinder.volumes.detach(volume_id)


def volume_attach(volume_id,inst_id):
    cinder.volumes.attach(volume_id,inst_id,"/dev/vdc","rw")


### FLOATING IP ###

def flt_ip_detach(instance_obj,flt_ip):
    instance_obj.remove_floating_ip(flt_ip)

def flt_ip_attach(instance_obj,flt_ip):
    instance_obj.add_floating_ip(flt_ip)
    




while True:
    dhosts = down_host()
    print len(dhosts)
    if len(dhosts) > 0 :
        uhosts = active_hosts()
        if len(dhosts) <= len(uhosts)+len(dhosts)-1:
            for dhost in dhosts:
                for instance_obj in list_instances(dhost.host):
                    inst_dict = parse_inst_details(instance_obj)
                    delete_instance_mysql(inst_dict['inst_id'],inst_dict['volume_id'],dhost.host)
                    create_instance(inst_dict['name'],inst_dict['volume_id'],inst_dict['flt_ip'])
                    time.sleep(5)
                host_delete(dhost)        
                print "Evacuation and host disabled"
        else:
            print "Not Enought Hosts Found "
    else:
        print "Running Normally"
    time.sleep(120)

