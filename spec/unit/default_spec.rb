require 'spec_helper'

describe 'windows_autologin_test::enable' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2', step_into: 'windows_autologin') do |node|
      node.override['windows_autologin']['username'] = 'test_user'
      node.override['windows_autologin']['password'] = 'Pass@word1'
    end.converge(described_recipe)
  end

  it 'calls enable resource' do
    expect(chef_run).to enable_windows_autologin('test_user')
  end

  it 'sets winlogon registry values' do
    expect(chef_run).to create_registry_key('set AutoAdminLogon for test_user').with(
      key: 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',
      values: [
        { name: 'AutoAdminLogon', type: :string, data: '1' },
        { name: 'DefaultUsername', type: :string, data: 'test_user' },
        { name: 'DefaultPassword', type: :string, data: 'Pass@word1' },
        { name: 'DefaultDomainName', type: :string, data: nil }
      ]
    )
  end

  it 'deletes AutoLogonCount' do
    expect(chef_run).to delete_registry_key('delete AutoLogonCount for test_user').with(
      key: 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    )
  end
end

describe 'windows_autologin_test::disable' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2', step_into: 'windows_autologin') do |node|
      node.override['windows_autologin']['username'] = 'test_user'
      node.override['windows_autologin']['password'] = 'Pass@word1'
      node.override['windows_autologin']['enable'] = false
    end.converge(described_recipe)
  end

  it 'calls disable resource' do
    expect(chef_run).to disable_windows_autologin('test_user')
  end

  it 'disables AutoAdminLogon' do
    expect(chef_run).to create_registry_key('disable AutoAdminLogon').with(
      key: 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',
      values: [{ name: 'AutoAdminLogon', type: :string, data: '0' }]
    )
  end

  it 'deletes DefaultPassword' do
    expect(chef_run).to delete_registry_key('delete DefaultPassword for test_user').with(
      key: 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',
      values: [{ name: 'DefaultPassword', type: :string, data: nil }]
    )
  end
end
