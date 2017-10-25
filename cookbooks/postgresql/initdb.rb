PGDATA   = node[:postgresql][:pgdata]
BIN_DIR  = node[:postgresql][:bin_dir]
ENCODING = node[:postgresql][:initdb_options][:encoding]
LOCALE   = node[:postgresql][:initdb_options][:locale]
INIT_COMMAND = "#{BIN_DIR}postgresql96-setup initdb".freeze

execute 'initdb' do
  command "PGSETUP_INITDB_OPTIONS='#{ENCODING} #{LOCALE}' #{INIT_COMMAND}"
  not_if "test -e #{PGDATA}postgresql.conf"
end

# service 'postgresql-9.6.service' do
#   # action %i[enable start]
#   action :start
# end
