# sudoers.d
systemctl_path = run_command("which systemctl").stdout.chomp
template '/etc/sudoers.d/postgres' do
  variables systemctl_path: systemctl_path
end
