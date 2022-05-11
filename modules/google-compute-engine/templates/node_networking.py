import ipaddress
import os


LOCAL_IP = '${local_ip}'
GRE_IP = '${gre_ip_cidr}'
CONTROL_PLANE_LOCAL_IP_LIST = ${cp_local_ip_list}
WORKER_LOCAL_IP_LIST = ${worker_local_ip_list}
GRE_CIDR = '${gre_cidr}'

os.system("sudo ip link add vxlan0 type vxlan id 42 dev ens4 dstport 0")
os.system("sudo ip addr add %s dev vxlan0" % GRE_IP)
NEIGHBOR_LOCAL_IP_LIST = CONTROL_PLANE_LOCAL_IP_LIST + WORKER_LOCAL_IP_LIST
n = 0
for neighbor_ip in NEIGHBOR_LOCAL_IP_LIST:
    if neighbor_ip != LOCAL_IP:
        gre_ip = list(ipaddress.ip_network(GRE_CIDR).hosts())[n].compressed
        os.system("sudo bridge fdb append to 00:00:00:00:00:00 dst %s dev vxlan0" % neighbor_ip)
    n = n + 1

os.system("sudo ip link set up dev vxlan0")
