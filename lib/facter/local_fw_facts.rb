require 'facter'

# Encapsulation for facts used by the Local FW module
#
module LocalFwFacts
  # Fact prefix
  @prefix = 'local_fw'.freeze

  # Path of ipv6 indicator
  @ipv6_check_file = '/proc/net/if_inet6'.freeze

  # Set host fact
  def self.set_fact(key, value)
    ::Facter.add("#{@prefix}_#{key}") do
      setcode { value }
    end
  end

  # Check to see if the ipv6 indicator file exists
  def self.check_ipv6_enabled
    set_fact('ipv6_enabled', (File.exist? @ipv6_check_file))
  end

  # Collect information and set facts
  def self.run
    check_ipv6_enabled
  end
end

LocalFwFacts.run
