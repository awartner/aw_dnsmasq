#
# Cookbook Name:: aw_dnsmasq
# Spec:: default
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

require 'spec_helper'

describe 'aw_dnsmasq::default' do
  context 'on Debian 9.0' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'debian', version: '9.0') do |node|
        node.automatic['ipaddress'] = '1.2.3.4'
        node.override['aw_dnsmasq']['server'] = { '1.2.3.1' => true }
        node.override['aw_dnsmasq']['network'] = '1.2.3.0/24'
        node.override['aw_dnsmasq']['managed_hosts'] = { '1.2.3.99' => { hostname: 'fake.example.com', aliases: ['fake'] } }
        node.override['aw_dnsmasq']['cnames'] = { 'alias.example.com' => 'fake.example.com' }
      end.converge(described_recipe)
    end

    let(:node) { chef_run.node }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'sets dnsmasq attributes' do
      expect(node['dnsmasq']['dns']).to include(domain: 'example.com')
      expect(node['dnsmasq']['dns']).to include(local: '/example.com/')
    end

    it 'listens on the nodes IP address' do
      expect(chef_run.node['dnsmasq']['dns_options']).to include('listen-address=1.2.3.4')
    end

    it 'assigns upstream DNS servers' do
      expect(chef_run.node['dnsmasq']['dns_options']).to include('server=1.2.3.1')
    end

    it 'assigns cnames' do
      expect(chef_run.node['dnsmasq']['dns_options']).to include('cname=alias.example.com,fake.example.com')
    end

    it 'adds hosts to the host file' do
      expect(chef_run).to create_hostsfile_entry('1.2.3.99')
        .with(hostname: 'fake.example.com', aliases: ['fake'])
    end

    it 'adds a firewall rule' do
      expect(chef_run).to enable_iptables_rule('dns').with(
        lines: '-A INPUT -s 1.2.3.0/24 -p tcp --dport domain -m state --state NEW -j ACCEPT
-A INPUT -s 1.2.3.0/24 -p udp --dport domain -j ACCEPT'
      )
    end
  end
end
