#!/bin/bash -x
# Recovery script for streaming replication.

pgdata=$1
remote_host=$2
remote_pgdata=$3
port=$4

pghome=/usr/pgsql-9.6
archivedir=/var/lib/pgsql/archivedir
hostname=$(hostname)

ssh -T postgres@$remote_host "
rm -rf $remote_pgdata
$pghome/bin/pg_basebackup -h $hostname -U repl -D $remote_pgdata -x -c fast
rm -rf $archivedir/*

cd $remote_pgdata
cp postgresql.conf postgresql.conf.bak
sed -e 's/#*hot_standby = off/hot_standby = on/' postgresql.conf.bak > postgresql.conf
rm -f postgresql.conf.bak
cat > recovery.conf << EOT
standby_mode = 'on'
primary_conninfo = 'host="$hostname" port=$port user=repl'
restore_command = 'scp $hostname:$archivedir/%f %p'
EOT
"

