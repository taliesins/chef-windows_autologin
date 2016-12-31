use_inline_resources

def whyrun_supported?
  true
end

WINLOGON_KEY = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'.freeze

action :enable do
  raise 'Password required!' if new_resource.password.nil?

  registry_key "set autologon for #{new_resource.username}" do
    key WINLOGON_KEY
    values [
      { name: 'AutoAdminLogon', type: :string, data: '1' },
      { name: 'DefaultUsername', type: :string, data: new_resource.username },
      { name: 'DefaultPassword', type: :string, data: new_resource.password },
      { name: 'DefaultDomainName', type: :string, data: new_resource.domain }
    ]
    sensitive new_resource.sensitive
    action :create
  end
end

action :disable do
  registry_key 'disable autologin' do
    key WINLOGON_KEY
    values [{ name: 'AutoAdminLogon', type: :string, data: '0' }]
    sensitive new_resource.sensitive
    action :create
  end

  registry_key 'delete autologin password' do
    key WINLOGON_KEY
    values [{ name: 'DefaultPassword', type: :string, data: nil }]
    sensitive new_resource.sensitive
    action :delete
  end
end
