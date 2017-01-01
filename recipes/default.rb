if platform?('windows')
  if node['windows_autologin']['enable']
    windows_autologin node['windows_autologin']['username'] do
      password node['windows_autologin']['password']
      domain node['windows_autologin']['domain']
      count node['windows_autologin']['count']
      action :enable
    end
  else
    windows_autologin node['windows_autologin']['username'] do
      action :disable
    end
  end
end
