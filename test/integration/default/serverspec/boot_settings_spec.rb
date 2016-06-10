require 'spec_helper'

# CENTOS
if ['rhel', 'fedora', 'centos', 'redhat'].include?(os[:family])

  # CENTOS6 1.4.2
  # CENTOS6 1.4.3
  describe file('/etc/selinux/config') do
    it { should exist }
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should contain "SELINUX=enforcing" }
    its(:content) { should contain "SELINUXTYPE=targeted" }
  end
  describe command('/usr/sbin/getenforce') do
    its(:stdout) { should match /Enforcing/ }
  end

  # CENTOS6: 1.4.1
  # CENTOS6: 1.5.3
  describe file('/etc/grub.conf') do
    it { should exist }
    it { should be_file }
    it { should be_linked_to '../boot/grub/grub.conf' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should_not contain "selinux=0" }
    its(:content) { should_not contain "enforcing=0" }
    its(:content) { should_not contain "password --md5" }
  end
  describe file('/boot/grub/grub.conf') do
    it { should exist }
    it { should be_file }
    it { should be_mode 600 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
  #
  describe command('stat -L -c "%u %g" /etc/grub.conf | egrep "0 0"') do
    its(:stdout) { should match /0 0/ }
  end
  # CENTOS6: 1.5.2
  describe command('stat -L -c "%a" /etc/grub.conf | egrep ".00"') do
    its(:stdout) { should_not match /^$/ }
  end

  # CENTOS6 1.4.4
  describe package('setroubleshoot') do
    it { should_not be_installed }
  end

  # CENTOS6 1.4.5
  describe package('mcstrans') do
    it { should_not be_installed }
  end

  # TODO- Bad test - Will not always be running on VirtualBox
  # CENTOS6: 1.4.6
  # describe command('ps -eZ | egrep "initrc" | egrep -vw "tr|ps|egrep|bash|awk" | tr ":" " " | awk "{ print $NF }"') do
  #   its(:stdout) { should match /^$|VBoxService/ }
  # end

  # CENTOS6: 1.5.5
  describe file('/etc/sysconfig/init') do
    it { should exist }
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should contain "PROMPT=no" }
  end

  # CENTOS6: 3.2
  describe file('/etc/inittab') do
    it { should exist }
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should contain "id:3:initdefault:" }
  end

  # CENTOS6: 5.2.1
  describe command('/sbin/sysctl net.ipv4.conf.all.accept_source_route') do
    its(:stdout) { should match /net.ipv4.conf.all.accept_source_route = 0/ }
  end
  describe command('/sbin/sysctl net.ipv4.conf.default.accept_source_route') do
    its(:stdout) { should match /net.ipv4.conf.default.accept_source_route = 0/ }
  end

  # CENTOS6: 5.2.2
  describe command('/sbin/sysctl net.ipv4.conf.all.accept_redirects') do
    its(:stdout) { should match /net.ipv4.conf.all.accept_redirects = 0/ }
  end
  describe command('/sbin/sysctl net.ipv4.conf.default.accept_redirects') do
    its(:stdout) { should match /net.ipv4.conf.default.accept_redirects = 0/ }
  end

  # CENTOS6: 5.2.3
  describe command('/sbin/sysctl net.ipv4.conf.all.secure_redirects') do
    its(:stdout) { should match /net.ipv4.conf.all.secure_redirects = 0/ }
  end
  describe command('/sbin/sysctl net.ipv4.conf.default.secure_redirects') do
    its(:stdout) { should match /net.ipv4.conf.default.secure_redirects = 0/ }
  end
end

# UBUNTU
if ['debian','ubuntu'].include?(host_inventory['platform'])
  # UBUNTU 3.1
  describe command('stat -c "%u %g" /boot/grub/grub.cfg | egrep "^0 0"') do
    its(:stdout) { should match /0 0/ }
  end

  # UBUNTU 3.2
  describe command('stat -L -c "%a" /boot/grub/grub.cfg | egrep ".00" ') do
    its(:stdout) { should_not match /^$/ }
  end
end
