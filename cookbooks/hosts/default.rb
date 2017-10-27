# # file "/etc/hosts" do
# file "/root/test" do
#   action :create
# end

# file "/root/test" do
#   action :delete
# end

FILE_NAME = node[:hosts][:file_name]
VIP       = node[:hosts][:vip]
FRONTEND  = node[:hosts][:frontend]
BACKEND   = node[:hosts][:backend]
BACKEND_PREFIX = node[:hosts][:backend_prefix]

file FILE_NAME do
  action :create
  not_if "test -e #{FILE_NAME}"
end

file FILE_NAME do
  action :edit
  block do |content|
    content << "\n"
    VIP.each do |val|
      content << "#{val[:ip]} #{val[:host]}\n"
    end
    content << "\n"
    FRONTEND.each do |val|
      content << "#{val[:ip]} #{val[:host]}\n"
    end
    content << "\n"
    BACKEND.each do |val|
      content << "#{val[:ip]} #{BACKEND_PREFIX}#{val[:host]}\n"
    end
  end
  not_if "grep '#{FRONTEND.first[:ip]}' #{FILE_NAME}"
end
