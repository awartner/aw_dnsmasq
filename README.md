# aw_dnsmasq

Installs and configures my name server.

## Requirements

### Platforms
 * Debian 9.0+

### Chef
 * Chef 13+

### Cookbooks
 - apt
 - dnsmasq
 - hostsfile
 - iptables

## Attributes
 - `default['aw_dnsmasq']['domain']` - the domain name
 - `default['aw_dnsmasq']['network']` - allow clients on this network
 - `default['aw_dnsmasq']['network']` - hash of upstream DNS servers, with enabled flag
 - `default['aw_dnsmasq']['managed_hosts']` - hosts to add to DNS
 - `default['aw_dnsmasq']['cnames']` - aliases to add to DNS

## Recipes

### Default
Setup a DNS server.

## Usage
Apply the default recipe to the node's run_list.

## License & Authors
**Author**: Aaron M. Wartner <aawartner@gmail.com>

**Copyright**: 2017 Aaron M. Wartner

```
The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
