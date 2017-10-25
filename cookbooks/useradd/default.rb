execute 'useradd postgres' do
  not_if 'grep postgres /etc/passwd'
end

execute %(ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa) do
  user 'postgres'
  not_if 'test -e ~/.ssh/id_rsa'
end
