name 'aw_dnsmasq'
maintainer 'Aaron M. Wartner'
maintainer_email 'aawartner@gmail.com'
license 'MIT'
description 'Installs and configures a DNS and DHCP server.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.1'

issues_url ''
source_url ''

chef_version '>= 13.0' if respond_to?(:chef_version)

supports 'debian', '>= 8.0'

depends 'apt', '~> 6.0'
depends 'dnsmasq'
depends 'hostsfile', '~> 3.0'
depends 'iptables', '~> 4.0'
