require 'spec_helper'

describe 'windows_autologin::default' do
  context 'enable' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2', step_into: 'windows_autologin') do |node|
        node.override['windows_autologin']['username'] = 'Administrator'
        node.override['windows_autologin']['password'] = 'password'
      end.converge(described_recipe)
    end

    it 'calls enable resource' do
      expect(chef_run).to enable_windows_autologin('Administrator')
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

  context 'disable' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2', step_into: 'windows_autologin') do |node|
        node.override['windows_autologin']['username'] = 'Administrator'
        node.override['windows_autologin']['password'] = 'password'
        node.override['windows_autologin']['enable'] = false
      end.converge(described_recipe)
    end

    it 'calls disable resource' do
      expect(chef_run).to disable_windows_autologin('Administrator')
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
        values: [{ name: 'DefaultPassword', type: :string, data: nil }]
      )
    end
  end
end
