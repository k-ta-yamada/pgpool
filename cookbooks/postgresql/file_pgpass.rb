PATH = node[:postgresql][:pgpass][:path]
BACKEND_PREFIX = node[:hosts][:backend_prefix]

file "#{PATH}.pgpass" do
  sample = "#hostname:port:database:username:password"
  entries = node[:postgresql][:pgpass][:entries].map do |h|
    host = "#{BACKEND_PREFIX}#{h[:host]}"
    "#{host}:#{h[:port]}:#{h[:database]}:#{h[:username]}:#{h[:password]}"
  end

  content Array(sample).concat(entries).join("\n")
  owner   'postgres'
  group   'postgres'
  mode    '600'
  only_if "test -d #{PATH}"
end
