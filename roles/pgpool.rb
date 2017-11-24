include_recipe '../cookbooks/hosts'

include_recipe '../cookbooks/pgpool-II'
include_recipe '../cookbooks/pgpool-II/conf'

service 'pgpool.service' do
  action :stop
end
