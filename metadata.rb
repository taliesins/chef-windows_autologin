name 'windows_autologin'
maintainer 'Dennis Hoer'
maintainer_email 'dennis.hoer@gmail.com'
license 'MIT'
description 'Configures Winlogon'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '4.0.0'

supports 'windows'

source_url 'https://github.com/dhoer/chef-windows_autologin' if respond_to?(:source_url)
issues_url 'https://github.com/dhoer/chef-windows_autologin/issues' if respond_to?(:issues_url)
