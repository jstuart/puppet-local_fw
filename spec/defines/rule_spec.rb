require 'spec_helper'

describe 'local_fw::rule' do
  let(:title) { 'allow all' }
  let(:params) do
    {
      action: 'accept',
      proto:  'all',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
