# Abstraction of a local firewall rule that can apply to either
# iptables or firewalld
#
# @summary Abstraction of a local firewall rule
#
# FIXME: this really needs additional options like source to
# be useful.
#
# @example
#   local_fw::rule { 'namevar': }
define local_fw::rule(
  Enum['present', 'absent'] $ensure = 'present',
  Integer[100,899] $order = 500,
  Enum['accept', 'reject', 'drop'] $action = undef,
  Variant[
    Undef,
    Integer,
    String,
    Array[
      Variant[
        Integer,
        String
      ]
    ]
  ] $port = undef,
  Variant[
    Undef,
    Enum[
      'all',
      'ip',
      'tcp',
      'udp',
      'icmp',
      'ipv4',
      'ipv6',
      'ipv6-icmp',
      'esp',
      'ah',
      'vrrp',
      'igmp',
      'ipencap',
      'ospf',
      'gre',
      'pim'
    ],
    Array[
      Enum[
        'all',
        'ip',
        'tcp',
        'udp',
        'icmp',
        'ipv4',
        'ipv6',
        'ipv6-icmp',
        'esp',
        'ah',
        'vrrp',
        'igmp',
        'ipencap',
        'ospf',
        'gre',
        'pim'
      ]
    ]
  ] $proto = undef,
) {
  include local_fw::params

  if $local_fw::globals::manage_firewall and $local_fw::params::_ensure != 'stopped' {
    if $port {
      if $proto =~ Array {
        $proto.each |String $p| {
          if $p != 'tcp' and $p != 'udp' and $p != 'all' {
            fail("Proto is required and must be tcp, udp, or all, for rules in which a port is specified. The current value is an array that contains: '${p}'.") # lint:ignore:140chars
          }
        }
      } else {
        if $proto != 'tcp' and $proto != 'udp' and $proto != 'all' {
          fail("Proto is required and must be tcp, udp, or all, for rules in which a port is specified. The current value is: '${proto}'.")
        }
      }
    }

    # Convert ports and protocols to arrays so we can just loop
    # through everything should we decide we need to later
    if $port =~ Array {
      $_ports = $port
    } else {
      $_ports = [$port]
    }

    if $proto =~ Array {
      $_protos = $proto
    } else {
      $_protos = [$proto]
    }

    case $local_fw::globals::firewall {
      'iptables': {
        if $ensure == 'absent' {
          if $proto {
            $_protos.each |String $_proto| {
              firewall { "${order} ${name} - ${_proto}":
                ensure => 'absent',
              }
            }
          } else {
            firewall { "${order} ${name}":
              ensure => 'absent',
            }
          }
        } else {
          include local_fw::iptables::pre
          include local_fw::iptables::post

          if $proto {
            $_protos.each |String $_proto| {
              firewall { "${order} ${name} - ${_proto}":
                ensure  => 'present',
                dport   => $port,
                proto   => $_proto,
                action  => $action,
                before  => Class['local_fw::iptables::post'],
                require => Class['local_fw::iptables::pre'],
              }
            }
          } else {
            firewall { "${order} ${name}":
              ensure  => 'present',
              dport   => $port,
              proto   => $proto,
              action  => $action,
              before  => Class['local_fw::iptables::post'],
              require => Class['local_fw::iptables::pre'],
            }
          }
        }
      }
      'firewalld': {
        if $ensure == 'absent' {
          # See the else clause for details about what's happing
          # in the loops below
          if $port {
            $_mapped = $_protos.each |Any $_proto| {
              $_ports.each |Any $_port| {
                firewalld_rich_rule { "${order} ${name} - ${_port}/${_proto}":
                  ensure =>  'absent',
                }
              }
            }
          } elsif $proto {
            $_filters = $_protos.each |Any $_proto| {
              firewalld_rich_rule { "${order} ${name} - ${_proto}":
                ensure => 'absent',
              }
            }
          } else {
            firewalld_rich_rule { "${order} ${name}":
              ensure => 'absent',
            }
          }
        } else {
          if $port {
            # If we have a port we'll filter on that

            # proto is required here and we can use the pre
            # created $_protos array

            # ports is also why we're here so we can use the
            # pre create $_ports array as well

            # Get an array of arrays of filter hashes
            $_mapped = $_protos.map |Any $_proto| {
              $_ports.map |Any $_port| {
                {
                  "${order} ${name} - ${_port}/${_proto}" => {
                    'port' => {
                      'port'     => $_port,
                      'protocol' => $_proto,
                    }
                  }
                }
              }
            }

            $_filters = flatten($_mapped)
          } elsif $proto {
            # If we don't have a port but we do have a protocol
            # we'll filter on that instead

            # proto is present so we can use the pre
            # create $_protos array

            # Get an array of filter hashes
            $_filters = $_protos.map |Any $_proto| {
              {
                "${order} ${name} - ${_proto}" => {
                  'protocol' => $proto,
                }
              }
            }
          } else {
            # If we don't have either a port or a protocol
            # then there are no filters
            $_filters = [
              {
                "${order} ${name}" => {}
              }
            ]
          }

          $_filters.each |Hash $_filter| {
            create_resources (
              firewalld_rich_rule,
              $_filter,
              {
                'ensure'  => 'present',
                'zone'    => $local_fw::globals::zone,
                'action'  => $action,
              }
            )
          }
        }
      }
      default: {
        fail("Unsupported firewall type: '${local_fw::globals::firewall}'.")
      }
    }
  }
}
