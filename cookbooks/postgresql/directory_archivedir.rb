ARCHIVEDIR = node[:postgresql][:common][:archivedir]

directory ARCHIVEDIR do
  owner 'postgres'
  group 'postgres'
  mode  '700'
  not_if "test -d #{ARCHIVEDIR}"
end
