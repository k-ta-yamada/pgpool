PGDATA   = node[:postgresql][:pgdata]
BIN_DIR  = node[:postgresql][:bin_dir]
ENCODING = node[:postgresql][:initdb_options][:encoding]
LOCALE   = node[:postgresql][:initdb_options][:locale]
INIT_COMMAND = "#{BIN_DIR}postgresql96-setup initdb".freeze

execute 'initdb' do
  command "PGSETUP_INITDB_OPTIONS='#{ENCODING} #{LOCALE}' #{INIT_COMMAND}"
  not_if "test -e #{PGDATA}postgresql.conf"
end

service 'postgresql-9.6.service' do
  # action %i[enable start]
  action :start
  only_if 'systemctl status postgresql-9.6.service'
end

# TODO: execute CREATE ROLE repl

# TODO: execute CREATE ROLE pgpool

# TODO: execute CREATE EXTENSION pgpool_recovery

# TODO: template pg_hba.conf

# TODO: template postgresql.conf

# TODO: file recovery_1st_stage
PGPOOL_CONF = node[:pgpool][:pgpool_conf]
remote_file "#{PGDATA}#{PGPOOL_CONF[:recovery_1st_stage_command]}" do
  source  './files/var/lib/pgsql/9.6/data/recovery_1st_stage.sh'
  owner   'postgres'
  group   'postgres'
  mode    '755'
  only_if "test -e #{PGDATA}postgresql.conf"
end
# TODO: file recovery_2nd_stage
remote_file "#{PGDATA}#{PGPOOL_CONF[:recovery_2nd_stage_command]}" do
  source  './files/var/lib/pgsql/9.6/data/recovery_2nd_stage.sh'
  owner   'postgres'
  group   'postgres'
  mode    '755'
  only_if "test -e #{PGDATA}postgresql.conf"
end
