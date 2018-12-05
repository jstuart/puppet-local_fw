# Class that controls the local firewall systems for either
# iptables or firewalld depending on the system.
#
# @summary Class that controls the local firewall of systems
#
# @example
#   include local_fw
class local_fw inherits local_fw::params {

  if $local_fw::globals::manage_firewall {
    case $local_fw::globals::firewall {
      'iptables': {
        contain local_fw::iptables::pre
        contain local_fw::iptables::post

        if $local_fw::globals::purge_rules {
          resources { 'firewall':
            purge  => $local_fw::globals::purge_rules,
          }
        }

        class { 'firewall':
          ensure => $local_fw::globals::ensure,
        }
      }
      'firewalld': {
        contain local_fw::firewalld::pre
        contain local_fw::firewalld::post

        class { 'firewalld':
          install_gui    => false,
          service_ensure => $local_fw::globals::ensure,
          service_enable => $local_fw::params::enable,
          default_zone   => $local_fw::globals::zone,
        }
      }
      default: {
        fail("Unsupported firewall type: '${local_fw::globals::firewall}'.")
      }
    }
  }
}
