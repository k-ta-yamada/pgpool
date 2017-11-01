# PostgreSQL HA

PostgreSQL High availability configuration by pgpool-II with watchdog.

> NOTE: This repository is for self-study.



## usage

### Using `itamae`

> NOTE: Please remove `--dry-run` option if you really want to apply

```sh
# install itamae
# NOTE: in the following command example omit "bundle exec"
bundle install --path vendor/bundle

# vagrant up
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-proxyconf # if you needed
vagrant up

# edit "/ etc / hosts", "/.ssh/config", etc. as necessary
# ex) ~/.ssh/config
#   Host pg1
#       HostName pg1
#       User root
#       Port 22
#       IdentityFile {this_repository_path}/.vagrant/machines/pg1/virtualbox/private_key
#   Host pg2
#       HostName pg2
#       User root
#       Port 22
#       IdentityFile {this_repository_path}/.vagrant/machines/pg2/virtualbox/private_key
# ex) /etc/hosts ref: node/develop.yml hosts.frontend and hosts.backend
#   192.168.1.200 pool #VIP
#   192.168.1.201 pg1  #front
#   192.168.1.202 pg2  #front
#   192.168.2.201 bpg1 #back
#   192.168.2.202 bpg2 #back

# An example of using a server built by yourself instead of vagrant
#   # setup server: change ip address, hostname, and reboot.
#   itamae ssh -h vm --node-yaml node/setup/pg1.yml   roles/setup.rb --dry-run
#   itamae ssh -h vm --node-yaml node/setup/pg2.yml   roles/setup.rb --dry-run
#   itamae ssh -h vm --node-yaml node/setup/pool1.yml roles/setup.rb --dry-run
#   itamae ssh -h vm --node-yaml node/setup/pool1.yml roles/setup.rb --dry-run

# database
itamae ssh --host pg1 --node-yaml node/develop.yml roles/db_master.rb --dry-run
itamae ssh --host pg2 --node-yaml node/develop.yml roles/db_slave.rb  --dry-run

# pgpool
itamae ssh --host pool1 --node-yaml node/develop.yml roles/pool1.rb --dry-run
itamae ssh --host pool2 --node-yaml node/develop.yml roles/pool2.rb --dry-run
```

### Remaining Task

- ssh-copy
  - for `pcp_recovery_node`.
- pcp_recovery_node
  - for start streaming replication.



## todo

- [ ] ssh-copy-id by postgres user
  - pg1 => pg2
  - pg2 => pg1
  - pool1 => pg1
  - pool1 => pg2
  - pool2 => pg1
  - pool2 => pg2
- [ ] get database user_name from xxx.yml
  - [ ] [./cookbooks/postgresql/create_role.rb](./cookbooks/postgresql/create_role.rb)
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



## refs:

- [Itamae by itamae-kitchen][itamae]
  - [Resources · itamae-kitchen/itamae Wiki][Resources]
  - [Best Practice · itamae-kitchen/itamae Wiki][Best-Practice]

---

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
