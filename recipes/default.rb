#
# Cookbook Name:: aw_dnsmasq
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2017 Aaron M. Wartner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

if node[cookbook_name]['domain'].nil?
  raise "Set attribute node[#{cookbook_name}]['domain']"
end

node.default['dnsmasq']['enable_dns'] = true

node.default['dnsmasq']['dns'] = {
  'domain' => node[cookbook_name]['domain'],
  'domain-needed' => nil,
  'bogus-priv' => nil,
  'no-poll' => nil,
  'no-resolv' => nil,
  'local' => "/#{node[cookbook_name]['domain']}/",
  'expand-hosts' => nil,
}

node.default['dnsmasq']['dns_options'] = [
  'listen-address=127.0.0.1',
  "listen-address=#{node['ipaddress']}",
]

node[cookbook_name]['server'].each do |addr, flag|
  node.default['dnsmasq']['dns_options'].push("server=#{addr}") if flag
end

node[cookbook_name]['cnames'].each do |cname, host|
  node.default['dnsmasq']['dns_options'].push("cname=#{cname},#{host}")
end

include_recipe 'dnsmasq::default'

node[cookbook_name]['managed_hosts'].each do |addr, names|
  hostsfile_entry addr do
    hostname names['hostname']
    aliases names['aliases']
    action :create
  end
end

include_recipe 'iptables'
iptables_rule 'dns' do
  lines "-A INPUT -s #{node[cookbook_name]['network']} -p tcp --dport domain -m state --state NEW -j ACCEPT
-A INPUT -s #{node[cookbook_name]['network']} -p udp --dport domain -j ACCEPT"
end
