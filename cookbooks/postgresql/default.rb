# ##################################################
# yum install
# ##################################################
package node[:postgresql][:rpm] do
  not_if 'rpm -q pgdg-centos96-9.6-3'
end

node[:postgresql][:pkg].each do |pkg|
  package pkg
end

# ##################################################
# yum install: FOR EXTENSION
# ##################################################
package node[:postgresql][:rpm_for_extension] do
  not_if 'rpm -q pgpool-II-release-3.6-1'
end

node[:postgresql][:pkg_for_extension].each do |pkg|
  package pkg
end
