include_recipe '../cookbooks/hosts'

include_recipe '../cookbooks/pgpool-II'

# MEMO: role側でホストごとに指定
template '/etc/pgpool-II/pgpool.conf' do
  source '../cookbooks/pgpool-II/templates/etc/pgpool-II/pgpool.conf.erb'
  variables(pgpool_conf: node[:pgpool][:pgpool_conf],
            wd_hostname:            'backend-pool2',
            heartbeat_destination0: 'backend-pool1',
            heartbeat_destination1: 'backend-pool3',
            other_pgpool_hostname0: 'backend-pool1',
            other_pgpool_hostname1: 'backend-pool3')
end

# MEMO: pg_md5の関連でpgpool.confの作成後に実行する必要がある
include_recipe '../cookbooks/pgpool-II/conf'

service 'pgpool.service' do
  # action %i[enable start]
  action :nothing
end

# include_recipe '../cookbooks/useradd'
