# ##################################################
# node
# ##################################################
ROLE      = node[:postgresql][:create_object][:role]
EXTENSION = node[:postgresql][:create_object][:extension]

# MEMO: CREATE ROLEなどの実行を行うためサービス起動する
service 'postgresql-9.6.service' do
  action :start
end

# ##################################################
# DROP ROLE
# ##################################################
ROLE.each do |role|
  drop_command = %(psql --command="DROP ROLE IF EXISTS #{role[:name]}")

  execute drop_command do
    user 'postgres'
  end
end

# ##################################################
# CREATE ROLE
# ##################################################
ROLE.each do |role|
  name     = role[:name]
  option   = role[:option]
  password = role[:password]
  sql = %W[CREATE ROLE #{name}]
  sql.concat(%w[WITH]).concat(option) unless option.nil?
  sql.concat(%w[PASSWORD]) << "'#{password}'" if password
  create_command = %(psql --command="#{sql.join("\s")}")

  execute create_command do
    user 'postgres'
  end
end

# ##################################################
# CREATE EXTENSION
# ##################################################
EXTENSION.each do |extension|
  name   = extension[:name]
  dbname = extension[:dbname] || 'postgres'
  option = extension[:option]
  sql = %W[CREATE EXTENSION IF NOT EXISTS #{name}]
  sql.concat(%w[WITH]).concat(option) unless option.nil?
  create_command = %(psql --dbname=#{dbname} --command="#{sql.join("\s")}")

  execute create_command do
    user 'postgres'
  end
end
