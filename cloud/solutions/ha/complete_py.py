#!/usr/bin/python
controller_ip="192.168.1.230"
target_host = "naanal-cloud"

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
    print host_obj.host
    nova.services.delete(host_obj.id)

### Instance Functions ###
    
def list_instances(host_name):
    ins_list = nova.servers.list(search_opts={'host':host_name})
    return ins_list    

def parse_inst_details(instance_obj):
    info = instance_obj._info
    inst_id = info.get('id')
    name = str(info.get('name'))
    image_id = str(info.get('image')['id'])
    flavor_id = str(info.get('flavor')['id'])
    key_name = str(info.get('key_name'))
    vol_ids = info.get('os-extended-volumes:volumes_attached')
    fixed_ip_list = []
    flt_ip_list = []
    
    vol_dict = {}

    for ip in info.get('addresses')['lan-net']:
        if ip['OS-EXT-IPS:type'] == 'floating':
            flt_ip_list.append(str(ip['addr']))
        elif ip['OS-EXT-IPS:type'] == 'fixed':
            fixed_ip_list.append(str(ip['addr']))
    
    for vol in vol_ids:
        mount = cinder.volumes.get(vol['id']).attachments[0]['device']
        vol_dict[vol['id']] = mount

    return dict([(key,eval(key)) for key in ('name','image_id','flavor_id','key_name','fixed_ip_list','flt_ip_list','vol_dict','inst_id')])


def delete_instance_mysql(uuid,volume_id,host_name,flt_ip_list):
    print "Fake Deletion"
    volume_detach(volume_id)
    
    tmp_ins_obj = nova.servers.get(uuid)
    flt_ip_detach(tmp_ins_obj,flt_ip_list)
    
    delete_q = "update nova.instances set deleted=1, deleted_at=now() where uuid='{0}' and  host = '{1}';".format(uuid,host_name)
    print(delete_q+"\n")
    delete_cur = con.cursor()
    delete_cur.execute(delete_q)
    delete_cur.close()
    con.commit()



def create_instance_mysql(name,volume_id,flt_ip_list):
    print "Fake Creation"
    # By using similiar Naming Pattern We should fetch and Turn on Standby Instance(it's uuid is unknown) Eg:(Active: test; Standby: test-ha)
    name = name + '-ha'

    uuid_q = "select uuid from nova.instances where display_name='{0}' and host='{1}';".format(name,target_host)
    print(uuid_q+"\n")
    uuid_cur = con.cursor()
    uuid_cur.execute(uuid_q)
    uuid = uuid_cur.fetchone()
    uuid_cur.close()
    con.commit()

    uuid = uuid[0]
    undelete_q = "update nova.instances set deleted=0,deleted_at=NULL where uuid='{0}';".format(uuid)
    print(undelete_q+"\n")
    undelete_cur = con.cursor()
    undelete_cur.execute(undelete_q)
    undelete_cur.close()
    con.commit()

    tmp_ins_obj = nova.servers.get(uuid)
    flt_ip_attach(tmp_ins_obj,flt_ip_list)
    volume_attach(volume_id,uuid)
    tmp_ins_obj.start()

    



### Cinder Functions ###
    
def volume_detach(vol_dict):
    for vol_id in vol_dict:
        print("Fake Volume detach",vol_id,"\n")
        cinder.volumes.detach(vol_id)


def volume_attach(vol_dict,inst_id):
    for vol_id in vol_dict:
        print("Fake Volume attach",vol_id,"\n",inst_id,vol_dict[vol_id])
        cinder.volumes.attach(vol_id,inst_id,vol_dict[vol_id],"rw")


### FLOATING IP ###

def flt_ip_detach(instance_obj,flt_ip_list):
    for flt_ip in flt_ip_list:
        print("Fake IP detach",instance_obj.name,"\n",flt_ip,"\n")    
        instance_obj.remove_floating_ip(flt_ip)

def flt_ip_attach(instance_obj,flt_ip_list):
    for flt_ip in flt_ip_list:
        print("Fake IP attach",instance_obj.name,"\n",flt_ip,"\n")    
        instance_obj.add_floating_ip(flt_ip)
    



def main():
    while True:
        dhosts = down_hosts()
        uhosts = active_hosts()
        print len(dhosts)
        if len(dhosts) > 0 :
            if len(dhosts) <= len(uhosts)+len(dhosts)-1:
                for dhost in dhosts:
                    for instance_obj in list_instances(dhost.host):
                        inst_dict = parse_inst_details(instance_obj)
                        try:
                            delete_instance_mysql(inst_dict['inst_id'],inst_dict['vol_dict'],dhost.host,inst_dict['flt_ip_list'])
                            create_instance_mysql(inst_dict['name'],inst_dict['vol_dict'],inst_dict['flt_ip_list'])
                        except:
                            pass
                        time.sleep(5)
                    host_delete(dhost)        
                    print "Evacuation and host disabled"
            else:
                print "Not Enough Hosts Found "
        else:
            print "Running Normally"
        time.sleep(120)

