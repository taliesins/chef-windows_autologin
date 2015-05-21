require 'spec_helper'

describe 'windows_autologin_test::disable' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'windows',
      version: '2012R2',
      step_into: ['windows_autologin']
    ).converge(described_recipe)
  end

  it 'disables AutoAdminLogon' do
    expect(chef_run).to create_registry_key('disable autologin').with(
      key: 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',
      values: [{ name: 'AutoAdminLogon', type: :string, data: '0' }]
    )
  end

  it 'deletes DefaultPassword' do
    expect(chef_run).to delete_registry_key('delete autologin password').with(
      key: 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',
      values: [{ name: 'DefaultPassword', type: :string, data: 'password', data: nil }]
    )
  end

  it 'disables autologin' do
    expect(chef_run).to disable_windows_autologin('Administrator')
  end
end
