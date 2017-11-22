remote_file '/etc/pgpool-II/failover.sh' do
  # source '/etc/pgpool-II/failover.sh'
  owner 'root'
  group 'root'
  mode  '755'
end

directory node[:pgpool][:pgpool_conf][:failover_log_dir]

node[:pgpool][:pcp_conf].each do |r|
  execute "echo #{r[:username]}:$(pg_md5 #{r[:md5auth]}) >> /etc/pgpool-II/pcp.conf"
end

# MEMO: role側でホストごとに指定
# template '/etc/pgpool-II/pgpool.conf' do
#   source '/etc/pgpool-II/pgpool.conf.erb'
#   variables(pgpool_conf: node[:pgpool][:pgpool_conf],
#             wd_hostname: 'pool1',
#             heartbeat_destination0: 'pool2',
#             heartbeat_destination1: 'pool3',
#             other_pgpool_hostname0: 'pool2',
#             other_pgpool_hostname1: 'pool3')
# end

template '/etc/pgpool-II/pool_hba.conf' do
  # source '/etc/pgpool-II/pool_hba.conf.erb'
  variables(pool_hba_conf: node[:pgpool][:pool_hba_conf])
end

node[:pgpool][:pool_passwd].each do |r|
  execute "pg_md5 --username #{r[:username]} --md5auth #{r[:md5auth]}"
end
