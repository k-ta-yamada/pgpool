HOSTNAME = node[:hostname]
DEVICES  = node[:devices]

execute "nmcli general hostname #{HOSTNAME}"

DEVICES.each do |dev|
  file "/etc/sysconfig/network-scripts/ifcfg-#{dev[:name]}" do
    action :edit
    block do |content|
      content.gsub!(dev[:old_ip], dev[:new_ip])
    end
  end
end

# execute "reboot"
