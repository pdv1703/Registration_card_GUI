#
# Cookbook:: pet_cookbook
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
data = data_bag_item('db_data', 'db_data')
Pregnant_Admin = data['Pregnant_Admin']
Pregnant_Admin_pass = data['Pregnant_Admin_pass']

cookbook_file File.join(Chef::Config[:file_cache_path], '/db_row.sql') do
  source 'db_row.sql'
  action :create
end

cookbook_file '/home/vagrant/HistoryStatistic.py' do
  source 'HistoryStatistic.py'
  action :create
end

execute 'yum -y update' do
  command 'yum -y update'
  live_stream true
end

include_recipe 'mariadb::server'

execute 'creating db' do
  command 'sudo mysql -e "CREATE DATABASE pregnant_application"'
  not_if 'sudo mysql  -e "show tables in pregnant_application"'
  live_stream true
end

execute 'Pregnant_Admin user creating' do
  command "sudo mysql -e \"CREATE USER '#{Pregnant_Admin}'@'localhost' identified by '#{Pregnant_Admin_pass}';\""
  notifies :run, 'execute[Pregnant_Admin user grant privileges]', :immediately
  not_if "mysql -u#{Pregnant_Admin} -p#{Pregnant_Admin_pass}"
end

execute 'Pregnant_Admin user grant privileges' do
  command "sudo mysql -e \"GRANT ALL PRIVILEGES ON pregnant_application. * TO '#{Pregnant_Admin}'@'localhost'\""
  action :nothing
end

database_schema = File.join(Chef::Config[:file_cache_path], '/db_row.sql')

execute 'import schema to pregnant_application' do
  command "sudo mysql -uroot  pregnant_application < #{database_schema}"
  not_if 'sudo mysql -e "select * from pregnant_application.authorization"'
end

yum_package 'yum-utils'

yum_package 'epel-release'
rpm_package 'ius-release-1.0-15.ius.centos7.noarch' do
  source 'https://centos7.iuscommunity.org/ius-release.rpm'
  action :install
end

yum_package 'python36u'

yum_package 'python36u-pip'

execute 'install mysql-connector==2.1.6' do
  command 'pip3.6 install mysql-connector==2.1.6'
  not_if 'pip3.6 show mysql-connector'
  live_stream true
end

execute 'install pyqt5' do
  command 'pip3.6 install pyqt5'
  not_if 'pip3.6 show PyQt5'
  live_stream true
end

execute 'install gnome desktop' do
  command 'yum -y groups install "GNOME Desktop"'
  not_if "yum grouplist | sed '/^Installed Environment Groups:/,$!d;/^Installed Groups:/,$d;/^Available Environment Groups:/,$d;/^Installed Environment Groups:/d;s/^[[:space:]]*//' | grep 'GNOME Desktop'"
  live_stream true
end
