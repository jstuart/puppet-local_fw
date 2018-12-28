# Global parameters that are used to control the local firewall
#
# @summary Global parameters that are used to control the local firewall
#
# @example
#   include local_fw::globals
class local_fw::globals (
  # Allow this module to be disabled entirely. Setting
  # this to false will leave all settings exactly as they
  # are, making the entire module a noop.
  Boolean $manage_firewall = true,

  # Allow switching between automatic firewall detection
  # based on operating system and iptables and firewalld
  # explicitly.
  Enum['auto', 'iptables', 'firewalld'] $system = 'auto',

  # Should the firewall be stopped or running?
  Enum['running', 'stopped'] $ensure = 'running',

  Enum['running', 'stopped', 'auto'] $ensure_ipv6 = 'auto',

  # Should all unmanaged rules be purged?
  Boolean $purge_rules = true,

  # Should SSH be allowed in?
  Boolean $allow_ssh = true,

  # Should ICMP traffic be allowed in
  Boolean $allow_icmp = true,

  # Override for firewalld zone
  String $zone = 'public',
) {

  $os_family = fact('os.family')
  $os_major = fact('os.release.major')

  case $os_family {
    'RedHat': {
      case $os_major {
        '6': {
          $detected_firewall = 'iptables'
        }
        '7': {
          $detected_firewall = 'firewalld'
        }
        default: {
          fail('This module only supports RedHat family systems with a major version of 6 or 7')
        }
      }
    }
    default: {
      fail('This module only supports RedHat family systems.')
    }
  }

  case $system {
    'iptables': {
      $firewall = 'iptables'
    }
    'firewalld': {
      $firewall = 'firewalld'
    }
    default: {
      $firewall = $detected_firewall
    }
  }
}
