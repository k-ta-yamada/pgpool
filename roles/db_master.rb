include_recipe '../cookbooks/hosts'

include_recipe '../cookbooks/postgresql'
include_recipe '../cookbooks/postgresql/directory_archivedir'
include_recipe '../cookbooks/postgresql/file_pgpass'
include_recipe '../cookbooks/postgresql/initdb'
include_recipe '../cookbooks/postgresql/conf'
include_recipe '../cookbooks/postgresql/create_role'
include_recipe '../cookbooks/postgresql/create_extension'

service 'postgresql-9.6.service' do
  action :stop
end
