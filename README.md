# PostgreSQL HA

PostgreSQL High availability configuration by pgpool-II with watchdog.

> NOTE: This repository is for self-study.



## Usage

### Server setup

```sh
# vagrant up
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-proxyconf # if you needed
vagrant up
vagrant reload # to reflect SELINUX setting change, reload.
```

### Using `itamae`

```sh
# install itamae
# NOTE: in the following command example omit "bundle exec"
bundle install --path vendor/bundle

# Primary node `pg1`: PostgreSQL and pgpool-II
itamae ssh -h pg1 -y node/develop.yml roles/db_master.rb
itamae ssh -h pg1 -y node/develop.yml roles/pool1.rb

# Standby node `pg2`: PostgreSQL and pgpool-II
itamae ssh -h pg2 -y node/develop.yml roles/db_slave.rb
itamae ssh -h pg2 -y node/develop.yml roles/pool2.rb
```

### Remaining 3 Task

#### 1. `ssh postgres@pg[1|2]` for `pcp_recovery_node`

Set up so that ssh connection without passphrase can be connected with `postgres` user from both servers.

> Note: host names used for the connection are `backend-pg1` and `backend-pg2`.  
> because `Streaming Replication` and `pg_basebackup` use the backend network.  
> ref: [./cookbooks/postgresql/templates/var/lib/pgsql/9.6/data/recovery_1st_stage.sh.erb#L18](./cookbooks/postgresql/templates/var/lib/pgsql/9.6/data/recovery_1st_stage.sh.erb#L18)  
> ref: [./cookbooks/pgpool-II/templates/etc/pgpool-II/pgpool.conf.erb#L65](./cookbooks/pgpool-II/templates/etc/pgpool-II/pgpool.conf.erb#L65)  
> please check `common.backend_prefix` and `common.hostnames` of `node/xxx.yml` for the actual host name.

1. generate key: `ssh-keygen` on both servers.
1. copy the contents of the public key to `~/.ssh/authorized_keys` of the other server
1. and copy the contents of the public key to `~/.ssh/authorized_keys` of the self
    - `cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys`
1. connect by postgres user
    - primary node: pg1
        1. `su - postgres`
        1. `ssh backend-pg1`
        1. `ssh backend-pg2`
    - standby node: pg2
        1. `su - postgres`
        1. `ssh backend-pg1`
        1. `ssh backend-pg2`

#### 2. Start up primary node and standby node(only pgpool)

> NOTE: Start up PostgreSQL with `pg_ctl` instead of `systemctl`.

primary node

```sh
ssh pg1
su - postgres
/usr/pgsql-9.6/bin/pg_ctl start -w -D /var/lib/pgsql/9.6/data/
exit
systemctl start pgpool.service
```

standby node

```sh
ssh pg2
su - postgres
systemctl start pgpool.service
```

and check node status

```sh
pcp_watchdog_info -h pool -U pgpool -v
Password:
Watchdog Cluster Information
Total Nodes          : 2
Remote Nodes         : 1
Quorum state         : QUORUM EXIST
Alive Remote Nodes   : 1
VIP up on local node : YES
Master Node Name     : backend-pool1:9999 Linux pg1
Master Host Name     : backend-pool1

Watchdog Node Information
Node Name      : backend-pool1:9999 Linux pg1
Host Name      : backend-pool1
Delegate IP    : 192.168.1.200
Pgpool port    : 9999
Watchdog port  : 9000
Node priority  : 1
Status         : 4
Status Name    : MASTER

Node Name      : backend-pool2:9999 Linux pg2
Host Name      : backend-pool2
Delegate IP    : 192.168.1.200
Pgpool port    : 9999
Watchdog port  : 9000
Node priority  : 1
Status         : 7
Status Name    : STANDBY
```

```sh
pcp_node_info -h pool -U pgpool -v 0
Password:
Hostname   : backend-pg1
Port       : 5432
Status     : 1
Weight     : 0.500000
Status Name: waiting
```

```sh
pcp_node_info -h pool -U pgpool -v 1
Password:
Hostname   : backend-pg2
Port       : 5432
Status     : 3
Weight     : 0.500000
Status Name: down
```

#### 3. Start up standby node

for start streaming replication.

```sh
pcp_recovery_node -h pool -U pgpool -n 1
```

#### Troubleshoot

If the execution of `pcp_recovery_node` fails, if the host OS is windows,  
check `recovery_1st_stage.sh.erb` or `recovery_1st_stage.sh` on the server.

In the case of windows

```sh
file cookbooks\postgresql\templates\var\lib\pgsql\9.6\data\recovery_1st_stage.sh.erb
```

On the server

```sh
file /var/lib/pgsql/9.6/data/recovery_1st_stage.sh
```

change `CRLF` to `LF` sample

```sh
sed -i "s/\r//g" /var/lib/pgsql/9.6/data/recovery_1st_stage.sh
```



---

## todo

- [ ] ssh-copy-id by postgres user
  - pg1 => pg2
  - pg2 => pg1
  - pool1 => pg1
  - pool1 => pg2
  - pool2 => pg1
  - pool2 => pg2
- [x] get database user_name from xxx.yml
  - [x] [./cookbooks/postgresql/create_role.rb](./cookbooks/postgresql/create_role.rb)
- [x] `epel-release` need? => don't need.
  - [x] [./roles/db_master.rb](./roles/db_master.rb)
  - [x] [./roles/db_slave.rb](./roles/db_slave.rb)
  - [x] [./roles/pool1.rb](./roles/pool1.rb)
  - [x] [./roles/pool2.rb](./roles/pool2.rb)
- [ ] database user
  - [ ] auth:
    - repl: Is there anything else you need?
    - pgpool: Is `SELECT` need?
  - [x] enable login by postgres user
    - `ALTER ROLE`
- [x] [recovery_1st_stage.sh](./cookbooks/postgresql/files/var/lib/pgsql/9.6/data/recovery_1st_stage.sh)
  - archivedir
  - `hostname=$(hostname)`
  - pg_basebackup
  - `rm -rf $archivedir/*`
  - recovery.conf
    - primary_conninfo



---

## refs:

- [Itamae by itamae-kitchen][itamae]
  - [Resources · itamae-kitchen/itamae Wiki][Resources]
  - [Best Practice · itamae-kitchen/itamae Wiki][Best-Practice]

- Qiita
  - [Itamaeチートシート - Qiita][qiita1]
  - [Chef脱落者が、Itamaeで快適インフラ生活する話 - Qiita][qiita2]
  - [itamae 入門 - Qiita][qiita3]
  - [itamae実践Tips - Qiita][qiita4]



[itamae]:        http://itamae.kitchen/
[Resources]:     https://github.com/itamae-kitchen/itamae/wiki/Resources
[Best-Practice]: https://github.com/itamae-kitchen/itamae/wiki/Best-Practice
[qiita1]:        https://qiita.com/fukuiretu/items/170aa956731f2ffb5715
[qiita2]:        https://qiita.com/zaru/items/8ae6182e544aac6f6d79
[qiita3]:        https://qiita.com/rasenn/items/8e234489b0d92ed74cfe
[qiita4]:        https://qiita.com/sue445/items/b67b0e7209a7fae1a52a
