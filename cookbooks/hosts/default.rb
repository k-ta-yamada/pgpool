FILE_NAME = node[:hosts][:file_name]
VIP       = node[:hosts][:vip]
FRONTEND  = node[:hosts][:frontend]
BACKEND   = node[:hosts][:backend]
BACKEND_PREFIX = node[:common][:backend_prefix]

stdout = run_command("cat #{FILE_NAME}").stdout
regexp = /(?<ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s*(?<hostname>.*$)/
HSOTS = stdout.split("\n")
              .reject(&:empty?)
              .map(&:chomp)
              .map { |v| v.match(regexp) }
              .compact
              .map(&:named_captures).map { |v| v["ip"] }
              .uniq

file FILE_NAME do
  action :edit
  block do |content|
    VIP.each do |val|
      content << "#{val[:ip]} #{val[:host]}\n" unless HSOTS.include?(val[:ip])
    end

    FRONTEND.each do |val|
      content << "#{val[:ip]} #{val[:host]}\n" unless HSOTS.include?(val[:ip])
    end

    BACKEND.each do |val|
      content << "#{val[:ip]} #{BACKEND_PREFIX}#{val[:host]}\n" unless HSOTS.include?(val[:ip])
    end
  end
end

execute "sed -i 's/\r//g' #{FILE_NAME}" do
  only_if "test -e #{FILE_NAME}"
end
