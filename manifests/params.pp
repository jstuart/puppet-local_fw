# Static parameters used by the local_fw class
#
# @summary Static parameters used by the local_fw class
#
# @example
#   include local_fw::params
class local_fw::params inherits local_fw::globals {

  $enable = $local_fw::globals::ensure ? {
    'running' => true,
    'stopped' => false,
    default   => false,
  }

  $rule_allow_all_icmp = '002 accept all icmp'
  $rule_allow_all_loopback = '003 allow all to loopback'
  $rule_reject_local_non_loopback = '004 reject local traffic not on loopback interface'
  $rule_accept_established_related = '001 accept established and related connections'
  $rule_accept_ssh = '010 accept ssh'
  $rule_drop_all_input = '999 drop all input'
  $rule_drop_all_forward = '999 drop all forward'

}
