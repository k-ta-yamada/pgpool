PGDATA          = node[:postgresql][:pgdata]
ARCHIVEDIR      = node[:postgresql][:archivedir]
PG_HBA_CONF     = node[:postgresql][:pg_hba_conf]
POSTGRESQL_CONF = node[:postgresql][:postgresql_conf]
RECOVERY_1ST_STAGE_SH = node[:postgresql][:recovery_1st_stage_sh]

PGPOOL_CONF        = node[:pgpool][:pgpool_conf]
RECOVERY_1ST_STAGE = PGPOOL_CONF[:recovery_1st_stage_command]
RECOVERY_2ND_STAGE = PGPOOL_CONF[:recovery_2nd_stage_command]

template "#{PGDATA}pg_hba.conf" do
  variables pg_hba_conf: PG_HBA_CONF
  source    './templates/var/lib/pgsql/9.6/data/pg_hba.conf.erb'
  owner     'postgres'
  group     'postgres'
  mode      '600'
end

template "#{PGDATA}postgresql.conf" do
  variables postgresql_conf: POSTGRESQL_CONF,
            archivedir:      ARCHIVEDIR
  source    './templates/var/lib/pgsql/9.6/data/postgresql.conf.erb'
  owner     'postgres'
  group     'postgres'
  mode      '600'
end

template "#{PGDATA}#{RECOVERY_1ST_STAGE}" do
  variables recovery_1st_stage_sh: RECOVERY_1ST_STAGE_SH,
            archivedir: ARCHIVEDIR
  source  './templates/var/lib/pgsql/9.6/data/recovery_1st_stage.sh.erb'
  owner   'postgres'
  group   'postgres'
  mode    '755'
  only_if "test -e #{PGDATA}postgresql.conf"
end

remote_file "#{PGDATA}#{RECOVERY_2ND_STAGE}" do
  source  './files/var/lib/pgsql/9.6/data/recovery_2nd_stage.sh'
  owner   'postgres'
  group   'postgres'
  mode    '755'
  only_if "test -e #{PGDATA}postgresql.conf"
end

service 'postgresql-9.6.service' do
  action :restart
end
