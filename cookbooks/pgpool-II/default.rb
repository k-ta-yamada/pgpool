package node[:pgpool][:rpm] do
  not_if 'rpm -q pgpool-II-release-3.6-1'
end

node[:pgpool][:pkg].each do |pkg|
  package pkg
end
