require 'spec_helper'

describe 'windows_autologin_test::enable' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'windows',
      version: '2012R2',
      step_into: ['windows_autologin']
    ).converge(described_recipe)
  end

  it 'sets winlogon registry values' do
    expect(chef_run).to create_registry_key(
      'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon').with(
        values: [
          { name: 'AutoAdminLogon', type: :string, data: '1' },
          { name: 'DefaultUsername', type: :string, data: 'Administrator' },
          { name: 'DefaultPassword', type: :string, data: 'password' },
          { name: 'DefaultDomainName', type: :string, data: nil }
        ]
      )
  end

  it 'enables autologin' do
    expect(chef_run).to enable_windows_autologin('Administrator').with(
      domain: nil,
      password: 'password')
  end
end
