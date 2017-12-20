cookbook_name = 'aw_dnsmasq'

default[cookbook_name]['domain'] = 'example.com'
default[cookbook_name]['network'] = '192.168.1.0/24'
default[cookbook_name]['server'] = {
  # '192.168.1.1' => true
}
default[cookbook_name]['managed_hosts'] = {
  # '192.168.1.11' => { hostname: 'example.tld', aliases: %w(example) }
}
default[cookbook_name]['cnames'] = {
  # 'alias.tld' => 'example.tld'
}
