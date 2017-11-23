#! /bin/sh -x
# Execute command by failover.
# special values:  %d = node id
#                  %h = host name
#                  %p = port number
#                  %D = database cluster path
#                  %m = new master node id
#                  %M = old master node id
#                  %H = new master node host name
#                  %P = old primary node id
#                  %R = new master database cluster path
#                  %r = new master port number
#                  %% = '%' character

node_id=$1                          # %d = node id
host_name=$2                        # %h = host name
port_number=$3                      # %p = port number
database_cluster_path=$4            # %D = database cluster path
new_master_node_id=$5               # %m = new master node id
old_master_node_id=$6               # %M = old master node id
new_master_node_host_name=$7        # %H = new master node host name
old_primary_node_id=$8              # %P = old primary node id
new_master_database_cluster_path=$9 # %R = new master database cluster path
# new_master_port_number=$1           # %r = new master port number

pghome=/usr/pgsql-9.6
log=/var/log/pgpool/failover.log

date >> $log
echo "  node_id                          = $node_id"                          >> $log
echo "  host_name                        = $host_name"                        >> $log
echo "  port_number                      = $port_number"                      >> $log
echo "  database_cluster_path            = $database_cluster_path"            >> $log
echo "  new_master_node_id               = $new_master_node_id"               >> $log
echo "  old_master_node_id               = $old_master_node_id"               >> $log
echo "  new_master_node_host_name        = $new_master_node_host_name"        >> $log
echo "  old_primary_node_id              = $old_primary_node_id"              >> $log
echo "  new_master_database_cluster_path = $new_master_database_cluster_path" >> $log

if [ $node_id = $old_primary_node_id ]; then
    if [ $UID -eq 0 ]
    then
        su postgres -c "ssh -T postgres@$new_master_node_host_name $pghome/bin/pg_ctl promote -D $new_master_database_cluster_path"
    else
        ssh -T postgres@$new_master_node_host_name $pghome/bin/pg_ctl promote -D $new_master_database_cluster_path
    fi
    exit 0;
fi;
exit 0;

