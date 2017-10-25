# PostgreSQL HA

PostgreSQL High availability configuration by pgpool-II with watchdog.

> NOTE: This repository is for self-study.

---

- [Itamae by itamae-kitchen][itamae]
  - [Resources · itamae-kitchen/itamae Wiki][Resources]
  - [Best Practice · itamae-kitchen/itamae Wiki][Best-Practice]

---

- Qiita
  - [Itamaeチートシート - Qiita][qiita1]
  - [Chef脱落者が、Itamaeで快適インフラ生活する話 - Qiita][qiita2]
  - [itamae 入門 - Qiita][qiita3]
  - [itamae実践Tips - Qiita][qiita4]

---

```sh
# install itamae
bundle install --path vendor/bundle

# setup server: change ip address, hostname, and reboot.
bundle exec itamae ssh -h vm --node-yaml node/setup/pg1.yml   roles/setup.rb --dry-run
bundle exec itamae ssh -h vm --node-yaml node/setup/pg2.yml   roles/setup.rb --dry-run
bundle exec itamae ssh -h vm --node-yaml node/setup/pool1.yml roles/setup.rb --dry-run
bundle exec itamae ssh -h vm --node-yaml node/setup/pool1.yml roles/setup.rb --dry-run

# database
bundle exec itamae ssh --host pg1 --node-yaml node/dev.yml roles/db_master.rb --dry-run
bundle exec itamae ssh --host pg2 --node-yaml node/dev.yml roles/db_slave.rb  --dry-run

# pgpool
bundle exec itamae ssh --host pool1 --node-yaml node/dev.yml roles/pool1.rb --dry-run
bundle exec itamae ssh --host pool2 --node-yaml node/dev.yml roles/pool2.rb --dry-run
```



[itamae]:        http://itamae.kitchen/
[Resources]:     https://github.com/itamae-kitchen/itamae/wiki/Resources
[Best-Practice]: https://github.com/itamae-kitchen/itamae/wiki/Best-Practice
[qiita1]:        https://qiita.com/fukuiretu/items/170aa956731f2ffb5715
[qiita2]:        https://qiita.com/zaru/items/8ae6182e544aac6f6d79
[qiita3]:        https://qiita.com/rasenn/items/8e234489b0d92ed74cfe
[qiita4]:        https://qiita.com/sue445/items/b67b0e7209a7fae1a52a
