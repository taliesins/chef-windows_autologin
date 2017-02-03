windows_autologin node['windows_autologin_test']['username'] do
  password node['windows_autologin_test']['password']
  action :enable
end
