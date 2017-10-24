package 'epel-release'
package 'epel-release' do
  not_if 'rpm -q epel-release'
end
