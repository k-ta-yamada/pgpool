# package 'nginx' do
#   action :uninstall
# end

# service 'nginx' do
#   action [:enable, :start]
# end

package 'epel-release.noarch' do
  action :install
end

package "https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm" do
  not_if 'rpm -q pgdg-centos96-9.6-3'
end

postgres = %w[
  postgresql96-server
  postgresql96-contrib
  postgresql96-libs
  postgresql96-devel
]
postgres.each { |pkg| package pkg }

execute 'initdb' do
  command "PGSETUP_INITDB_OPTIONS='--encoding UTF8 --no-locale' /usr/pgsql-9.6/bin/postgresql96-setup initdb"
  not_if 'test -e /var/lib/pgsql/9.6/data/postgresql.conf'
end

service 'postgresql-9.6.service' do
  action %i[enable start]
end
