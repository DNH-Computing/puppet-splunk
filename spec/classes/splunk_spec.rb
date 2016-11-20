require 'spec_helper'

describe 'splunk' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'splunk class without any parameters' do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('splunk::params') }

          it { is_expected.to contain_service('splunk') }
          it { is_expected.to contain_package('splunk').with_ensure('installed') }

          it { is_expected.to contain_exec('license_splunk').with_user('root') }
          it { is_expected.to contain_exec('enable_splunk').with_command(%r{-user root}) }
        end

        context 'splunk class with splunk_user' do
          let(:params) do
            { splunk_user: 'splunk' }
          end

          it { is_expected.to contain_exec('license_splunk').with_user('splunk') }
          it { is_expected.to contain_exec('enable_splunk').with_command(%r{-user splunk}) }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'splunk class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          osfamily:        'Solaris',
          operatingsystem: 'Nexenta',
          kernel:          'SunOS',
          architecture:    'sparc'
        }
      end

      it { expect { is_expected.to contain_package('splunk') }.to raise_error(Puppet::Error, %r{unsupported osfamily/arch Solaris/sparc}) }
    end
  end
end
