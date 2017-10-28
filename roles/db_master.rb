include_recipe '../cookbooks/hosts'

include_recipe '../cookbooks/postgresql'
include_recipe '../cookbooks/postgresql/initdb'
include_recipe '../cookbooks/postgresql/conf'
include_recipe '../cookbooks/postgresql/create_object'

service 'postgresql-9.6.service' do
  action :stop
end
