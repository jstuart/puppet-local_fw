# Initial rules for the iptables firewall system
#
# @summary Initial rules for the iptables firewall system
#
# Note that this class is for internal use only and should
# not be directly used.
#
class local_fw::iptables::pre inherits local_fw::params {

  Firewall {
    require => undef,
  }

  firewall { $local_fw::params::rule_accept_established_related:
    proto  => 'all',
    state  => ['ESTABLISHED', 'RELATED'],
    action => 'accept',
  }

  if $local_fw::globals::allow_icmp {
    firewall { $local_fw::params::rule_allow_all_icmp:
      proto   => 'icmp',
      action  => 'accept',
      before  => Firewall[$local_fw::params::rule_allow_all_loopback],
      require => Firewall[$local_fw::params::rule_accept_established_related],
    }
  }

  firewall { $local_fw::params::rule_allow_all_loopback:
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
    require => Firewall[$local_fw::params::rule_accept_established_related],
  }

  firewall { $local_fw::params::rule_reject_local_non_loopback:
    iniface     => '! lo',
    proto       => 'all',
    destination => '127.0.0.1/8',
    action      => 'reject',
    require     => Firewall[$local_fw::params::rule_allow_all_loopback],
  }

  if $local_fw::globals::allow_ssh {
    firewall { $local_fw::params::rule_accept_ssh:
      state   => 'NEW',
      dport   => 22,
      proto   => 'tcp',
      action  => 'accept',
      require => Firewall[$local_fw::params::rule_reject_local_non_loopback],
    }
  }
}
