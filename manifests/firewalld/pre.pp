# Initial rules for the firewalld firewall system
#
# @summary Initial rules for the firewalld firewall system
#
# Note that this class is for internal use only and should
# not be directly used.
#
class local_fw::firewalld::pre inherits local_fw::params {

  if $local_fw::globals::allow_icmp {
    $icmp_blocks = ['echo-reply']
  } else {
    $icmp_blocks = undef
  }

  # FIXME this doesn't do anything about associating interfaces with
  # the actual zone. We probably need to specify 'interfaces'.
  firewalld_zone { $local_fw::globals::zone:
    ensure           => 'present',
    target           => '%%REJECT%%',
    masquerade       => false,
    icmp_blocks      => $icmp_blocks,
    purge_rich_rules => $local_fw::globals::purge_rules,
    purge_services   => $local_fw::globals::purge_rules,
    purge_ports      => $local_fw::globals::purge_rules,
  }

  if $local_fw::globals::allow_ssh {
    firewalld_service { $local_fw::params::rule_accept_ssh:
      ensure  => 'present',
      service => 'ssh',
      zone    => $local_fw::globals::zone,
    }
  }
}
