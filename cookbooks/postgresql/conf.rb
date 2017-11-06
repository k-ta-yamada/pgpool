PGDATA          = node[:postgresql][:common][:pgdata]
ARCHIVEDIR      = node[:postgresql][:common][:archivedir]

PG_HBA_CONF     = node[:postgresql][:pg_hba_conf]
POSTGRESQL_CONF = node[:postgresql][:postgresql_conf]
RECOVERY_1ST_STAGE_SH = node[:postgresql][:recovery_1st_stage_sh]

BACKEND_PREFIX = node[:hosts][:backend_prefix]

PGPOOL_CONF        = node[:pgpool][:pgpool_conf]
RECOVERY_1ST_STAGE = PGPOOL_CONF[:recovery_1st_stage_command]
RECOVERY_2ND_STAGE = PGPOOL_CONF[:recovery_2nd_stage_command]

template "#{PGDATA}pg_hba.conf" do
  variables pg_hba_conf: PG_HBA_CONF
  source    './templates/var/lib/pgsql/9.6/data/pg_hba.conf.erb'
  owner     'postgres'
  group     'postgres'
  mode      '600'
  only_if "test -d #{PGDATA}"
end

template "#{PGDATA}postgresql.conf" do
  variables postgresql_conf: POSTGRESQL_CONF,
            archivedir:      ARCHIVEDIR
  source    './templates/var/lib/pgsql/9.6/data/postgresql.conf.erb'
  owner     'postgres'
  group     'postgres'
  mode      '600'
  only_if "test -d #{PGDATA}"
end

template "#{PGDATA}#{RECOVERY_1ST_STAGE}" do
  variables recovery_1st_stage_sh: RECOVERY_1ST_STAGE_SH,
            backend_prefix: BACKEND_PREFIX,
            archivedir: ARCHIVEDIR
  source  './templates/var/lib/pgsql/9.6/data/recovery_1st_stage.sh.erb'
  owner   'postgres'
  group   'postgres'
  mode    '755'
  only_if "test -d #{PGDATA}"
end

remote_file "#{PGDATA}#{RECOVERY_2ND_STAGE}" do
  source  './files/var/lib/pgsql/9.6/data/pgpool_remote_start'
  owner   'postgres'
  group   'postgres'
  mode    '755'
  only_if "test -d #{PGDATA}"
end

service 'postgresql-9.6.service' do
  action :restart
end
