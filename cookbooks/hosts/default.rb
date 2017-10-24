# # file "/etc/hosts" do
# file "/root/test" do
#   action :create
# end

# file "/root/test" do
#   action :delete
# end

FILE_NAME = node[:hosts][:file_name]

file FILE_NAME do
  action :create
  not_if "test -e #{FILE_NAME}"
end

# node[:hosts][:vals].each do |val|
#   file FILE_NAME do
#     action :edit
#     block { |content| content << "#{val}\n" }
#     not_if "grep '#{val}' #{FILE_NAME}"
#   end
# end

file FILE_NAME do
  action :edit
  block do |content|
    node[:hosts][:vals].each do |val|
      content << "#{val}\n"
    end
  end
  not_if "grep '#{node[:hosts][:vals].first}' #{FILE_NAME}"
end
