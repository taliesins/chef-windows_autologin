registry_key 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' do
  values [
    { name: 'AutoAdminLogon', type: :string, data: '1' },
    { name: 'DefaultUsername', type: :string, data: node['windows_autologin']['username'] },
    { name: 'DefaultPassword', type: :string, data: node['windows_autologin']['password'] },
    { name: 'DefaultDomainName', type: :string, data: node['windows_autologin']['domain'] }
  ]
  action :create
end
