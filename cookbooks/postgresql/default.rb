package node[:postgresql][:rpm] do
  not_if 'rpm -q pgdg-centos96-9.6-3'
end

node[:postgresql][:pkg].each do |pkg|
  package pkg
end
