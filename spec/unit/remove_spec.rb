require 'spec_helper'

describe 'windows_autologin::remove' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2').converge(described_recipe)
  end

  it 'disables AutoAdminLogon' do
    expect(chef_run).to create_registry_key('disable autologin').with(
      key: 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',
      values: [{ name: 'AutoAdminLogon', type: :string, data: '0' }]
    )
  end

  it 'deletes DefaultPassword' do
    expect(chef_run).to delete_registry_key('delete autologin password').with(
      key: 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',
      values: [{ name: 'DefaultPassword', type: :string, data: 'password', data: nil }]
    )
  end
end
