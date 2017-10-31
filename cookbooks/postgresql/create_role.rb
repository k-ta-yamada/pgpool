# ##################################################
# node
# ##################################################
ROLE = node[:postgresql][:create_role]

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
