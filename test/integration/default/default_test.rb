# # encoding: utf-8

# Inspec test for recipe aw_dnsmasq::firewall

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe port('53') do
  it { should be_listening }
  its(:protocols) { should include 'tcp' }
  its(:protocols) { should include 'udp' }
end

describe command('/sbin/iptables -L') do
  its(:stdout) { should match(%r{ACCEPT\s+tcp\s+--\s+192.168.1.0\/24\s+anywhere\s+tcp dpt:domain state NEW}) }
  its(:stdout) { should match(%r{ACCEPT\s+tcp\s+--\s+192.168.1.0\/24\s+anywhere\s+tcp dpt:domain}) }
end
