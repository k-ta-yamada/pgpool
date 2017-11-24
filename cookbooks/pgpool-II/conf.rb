BACKEND_PREFIX = node[:common][:backend_prefix]

template '/etc/pgpool-II/pgpool.conf' do
  hostname = run_command("hostname").stdout.chomp
  depend_on_hostname = node[:pgpool][:pgpool_conf][:depend_on_hostname][hostname]

  variables backend_prefix: BACKEND_PREFIX,
            pgpool_conf: node[:pgpool][:pgpool_conf],
            depend_on_hostname: depend_on_hostname
end

directory node[:pgpool][:common][:rundir]
directory node[:pgpool][:common][:logdir]

remote_file '/etc/pgpool-II/failover.sh' do
  owner 'root'
  group 'root'
  mode  '755'
end

execute "sed -i 's/\r//g' /etc/pgpool-II/failover.sh" do
  only_if "test -e /etc/pgpool-II/failover.sh"
end

remote_file "/etc/pgpool-II/pcp.conf"
node[:pgpool][:pcp_conf].each do |r|
  execute "echo #{r[:username]}:$(pg_md5 #{r[:md5auth]}) >> /etc/pgpool-II/pcp.conf"
end

template '/etc/pgpool-II/pool_hba.conf' do
  variables pool_hba_conf: node[:pgpool][:pool_hba_conf]
end

node[:pgpool][:pool_passwd].each do |r|
  execute "pg_md5 --username #{r[:username]} --md5auth #{r[:md5auth]}"
end
