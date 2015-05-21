WINLOGON_KEY ||= 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

def whyrun_supported?
  true
end

use_inline_resources

action :enable do
  converge_by('windows autologin enable') do
    registry_key WINLOGON_KEY do
      values [
        { name: 'AutoAdminLogon', type: :string, data: '1' },
        { name: 'DefaultUsername', type: :string, data: new_resource.username },
        { name: 'DefaultPassword', type: :string, data: new_resource.password },
        { name: 'DefaultDomainName', type: :string, data: new_resource.domain }
      ]
      sensitive true
      action :create
    end
  end
end

action :disable do
  converge_by('windows autologin disable') do
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
  end
end
