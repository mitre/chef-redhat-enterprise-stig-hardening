# Cookbook Name:: stig
# Recipe:: avahi_daemon
# Author: Ivan Suftin <isuftin@usgs.gov>
#
# Description: Manage Avahi daemin
#
# CIS Benchmark Items
# RHEL6:  3.3
# CENTOS6: 3.3
#
# - Disable AVAHI server

execute "chkconfig_avahi-daemon_off" do
  user "root"
  command "/sbin/chkconfig avahi-daemon off"
  action :run
  only_if "/sbin/chkconfig | grep 'avahi-daemon' | grep 'on'"
end