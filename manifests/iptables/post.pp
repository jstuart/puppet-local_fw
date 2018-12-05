# Final rules for the iptables firewall system
#
# @summary Final rules for the iptables firewall system
#
# Note that this class is for internal use only and should
# not be directly used.
#
class local_fw::iptables::post inherits local_fw::params {
  firewall { $local_fw::params::rule_drop_all_input:
    proto  => 'all',
    action => 'reject',
    reject => 'icmp-host-prohibited',
    before => undef,
  }

  firewall { $local_fw::params::rule_drop_all_forward:
    chain  => 'FORWARD',
    proto  => 'all',
    action => 'reject',
    reject => 'icmp-host-prohibited',
    before => undef,
  }
}
