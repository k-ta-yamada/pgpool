# ##################################################
# yum install
# ##################################################
package node[:postgresql][:rpm] do
  # not_if 'rpm -q pgdg-centos96-9.6-3'
  # not_if 'rpm -q pgdg-redhat96-9.6-3'
  not_if "rpm -q #{File.basename(node[:postgresql][:rpm], '.noarch.rpm')}"
end

node[:postgresql][:pkg].each do |pkg|
  package pkg
end

# MEMO: Change 'Environment=PGDATA' for starting with systemd
template "/etc/systemd/system/postgresql-9.6.service" do
  variables environment_pgdata: node[:postgresql][:common][:pgdata]
end
execute 'systemctl daemon-reload'

# ##################################################
# yum install: FOR EXTENSION
# ##################################################
package node[:postgresql][:rpm_for_extension] do
  not_if 'rpm -q pgpool-II-release-3.6-1'
end

node[:postgresql][:pkg_for_extension].each do |pkg|
  package pkg
end
