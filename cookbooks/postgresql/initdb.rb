BINDIR = node[:postgresql][:common][:bindir]
PGDATA = node[:postgresql][:common][:pgdata]
SUPERUSER_PASSWORD = node[:postgresql][:common][:superuser_password]

INITDB  = node[:postgresql][:initdb]
SU_USER = INITDB[:su][:user]

INITDB_OPTION  = INITDB[:option].map { |key, val| "--#{key}=#{val}" }
INITDB_COMMAND = %W[#{BINDIR}initdb].concat(INITDB_OPTION).join("\s")

service 'postgresql-9.6.service' do
  action :stop
end

# MEMO: ディレクトを削除すると本番機だとまずそうなのでファイル削除
execute "rm -rf #{PGDATA}*"

# MEMO: initdb時にpostgresユーザのパスワードを設定するためのファイル
file INITDB[:option][:pwfile] do
  content SUPERUSER_PASSWORD
  mode '644'
end

# ##################################################
# initdb
# ##################################################
execute 'initdb' do
  user    SU_USER
  command INITDB_COMMAND
  not_if  "test -e #{PGDATA}postgresql.conf"
end

# MEMO: initdb完了後はpwfileは不要なため削除
file INITDB[:option][:pwfile] do
  action :delete
end

# MEMO: 動作確認かねて起動する
service 'postgresql-9.6.service' do
  action :start
end
