nic_dev_name = node[:nic_dev_name]
hostname     = node[:hostname]
ip           = node[:ip]

execute "nmcli general hostname #{hostname}"

# execute "nmcli device modify #{nic_dev_name} ipv4.addresses #{ip}/24"
file "/etc/sysconfig/network-scripts/ifcfg-#{nic_dev_name}" do
  action :edit
  block do |content|
    content.gsub!("192.168.250.100", "#{ip}")
  end
end

execute "reboot"
