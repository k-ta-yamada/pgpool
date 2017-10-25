include_recipe '../cookbooks/hosts'

# # TODO: need this?
include_recipe '../cookbooks/epel-release'

include_recipe '../cookbooks/pgpool-II'

include_recipe '../cookbooks/pgpool-II/conf'

# MEMO: role側でホストごとに指定
template '/etc/pgpool-II/pgpool.conf' do
  source '../cookbooks/pgpool-II/templates/etc/pgpool-II/pgpool.conf.erb'
  variables(pgpool_conf: node[:pgpool][:pgpool_conf],
            wd_hostname:            'pool2',
            heartbeat_destination0: 'pool1',
            heartbeat_destination1: 'pool3',
            other_pgpool_hostname0: 'pool1',
            other_pgpool_hostname1: 'pool3')
end

include_recipe '../cookbooks/useradd'
