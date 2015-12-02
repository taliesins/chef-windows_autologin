WINLOGON_KEY = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

if node['windows_autologin']['enable']
  winlogin_keys = [
      { name: 'AutoAdminLogon', type: :string, data: '1' },
      { name: 'DefaultUsername', type: :string, data: node['windows_autologin']['username'] },
      { name: 'DefaultPassword', type: :string, data: node['windows_autologin']['password'] },
      { name: 'DefaultDomainName', type: :string, data: node['windows_autologin']['domain'] }
    ]

  if node['windows_autologin']['autologoncount']
    winlogin_keys << { name: 'AutoLogonCount', type: :string, dword: node['windows_autologin']['autologoncount'] }
  end

  registry_key "set autologon for #{node['windows_autologin']['username']}" do
    key WINLOGON_KEY
    values winlogin_keys
    action :create
  end
else
  registry_key 'disable autologin' do
    key WINLOGON_KEY
    values [{ name: 'AutoAdminLogon', type: :string, data: '0' }]
    action :create
  end

  registry_key 'delete autologin password' do
    key WINLOGON_KEY
    values [{ name: 'DefaultPassword', type: :string, data: nil }]
    action :delete
  end

  registry_key 'delete AutoLogonCount' do
    key WINLOGON_KEY
    values [{ name: 'AutoLogonCount', type: :dword, data: '0' }]
    action :delete
  end  
end
