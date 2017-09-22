require 'spec_helper'

describe 'artifactory_ha' do
  let(:params) {
    {
      license_file: 'my_license_file',
      jdbc_driver_url: 'http://autostructure.com/my_url',
      db_type: 'mysql',
      db_url: 'jdbc:oracle:sad',
      db_username: 'my_db_user',
      db_password: 'egpiqwgoq[hgewoiehf]',
      security_token: '123security_token_4me',
      is_primary: true,
      cluster_home: '/nfs/home/mnt'
    }
  }

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "artifactory_ha class with minimum configs" do
          it { is_expected.to compile.with_all_deps }

          # it { is_expected.to contain_class('artifactory_pro::params') }
          it { is_expected.to contain_class('artifactory_pro').that_comes_before('artifactory_ha::config') }
          it { is_expected.to contain_class('artifactory_ha::config').that_comes_before('artifactory_ha::post_config') }
          it { is_expected.to contain_class('artifactory_ha::config') }
          it { is_expected.to contain_class('artifactory_ha::post_config') }
          it { is_expected.to contain_class('artifactory::service').that_subscribes_to('artifactory_ha::config') }
          it { is_expected.to contain_class('artifactory::service').that_subscribes_to('artifactory_ha::post_config') }

          it { is_expected.to contain_service('artifactory') }
          it { is_expected.to contain_package('jfrog-artifactory-pro').with_ensure('present') }
        end
      end
    end
  end
end
