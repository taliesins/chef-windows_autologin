require 'serverspec_helper'

describe 'windows_autologin::default' do
  if os[:family] == 'windows'
    describe windows_registry_key('HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon') do
      it { should exist }
      it { should have_property_value('AutoAdminLogon', :type_string, '1') }
      it { should have_property('DefaultUsername', :type_string) }
      it { should have_property('DefaultPassword', :type_string) }
      it { should have_property('DefaultDomainName', :type_string) }
      it { should_not have_property('AutoLogonCount', :type_dword) }
    end
  end
end
