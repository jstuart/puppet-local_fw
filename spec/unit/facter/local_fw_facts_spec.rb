require 'spec_helper'
require 'facter/local_fw_facts'

describe 'local_fw facts' do
  before(:each) do
    Facter.clear
  end

  context 'with ipv6 disabled' do
    before(:each) do
      allow(File).to receive(:exist?).and_return(false)
      allow(File).to receive(:exist?).with('/proc/net/if_inet6').and_return(false)
    end

    describe 'local_fw_ipv6_enabled' do
      it 'returns false' do
        expect(Facter.fact(:local_fw_ipv6_enabled).value).to eq(false)
      end
    end
  end

  context 'with ipv6 enabled' do
    before(:each) do
      allow(File).to receive(:exist?).and_return(false)
      allow(File).to receive(:exist?).with('/proc/net/if_inet6').and_return(true)
    end

    describe 'local_fw_ipv6_enabled' do
      it 'returns true' do
        expect(Facter.fact(:local_fw_ipv6_enabled).value).to eq(true)
      end
    end
  end
end
