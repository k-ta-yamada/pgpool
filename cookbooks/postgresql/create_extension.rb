# ##################################################
# node
# ##################################################
EXTENSION = node[:postgresql][:create_extension]

# MEMO: CREATE ROLEなどの実行を行うためサービス起動する
service 'postgresql-9.6.service' do
  action :start
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
