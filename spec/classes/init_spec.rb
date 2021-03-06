require 'spec_helper'

describe 'icingaweb2', :type => :class do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      before(:all) do
        @conf_dir = '/etc/icingaweb2'
      end

      context 'with all default parameters' do
        it { is_expected.to compile }

        it { is_expected.to contain_class('icingaweb2::config') }
        it { is_expected.to contain_class('icingaweb2::install') }
        it { is_expected.to contain_class('icingaweb2::params') }
        it { is_expected.to contain_class('icingaweb2::repo') }

        it { is_expected.to contain_package('icingaweb2').with({ 'ensure' => 'installed' }) }

        it { is_expected.to contain_file(@conf_dir + "/authentication.ini") }
        it { is_expected.to contain_file(@conf_dir + "/config.ini") }
        it { is_expected.to contain_file(@conf_dir + "/roles.ini") }
        it { is_expected.to contain_file(@conf_dir + "/groups.ini") }

        case facts[:osfamily]
          when 'Debian'
            it { should_not contain_apt__source('icinga-stable-release') }
          when 'RedHat'
            it { should_not contain_yumrepo('icinga-stable-release') }
          when 'Suse'
            it { should_not contain_zypprepo('icinga-stable-release') }
        end

        context "#{os} with manage_package => false" do
          let(:params) { {:manage_package => false} }

          it { should_not contain_package('icinga2').with({ 'ensure' => 'installed' }) }
        end
      end
    end
  end
end