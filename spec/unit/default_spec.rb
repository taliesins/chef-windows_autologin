require 'spec_helper'

describe 'windows_autologin::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2') do |node|
      node.set['windows_autologin']['username'] = 'Administrator'
      node.set['windows_autologin']['password'] = 'password'
    end.converge(described_recipe)
  end

  it 'sets winlogon registry values' do
    expect(chef_run).to create_registry_key('set autologon for Administrator').with(
      key: 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',
      values: [
        { name: 'AutoAdminLogon', type: :string, data: '1' },
        { name: 'DefaultUsername', type: :string, data: 'Administrator' },
        { name: 'DefaultPassword', type: :string, data: 'password' },
        { name: 'DefaultDomainName', type: :string, data: nil }
      ]
    )
  end
end
