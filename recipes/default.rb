#
# Cookbook:: pet_cookbook
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
data = data_bag_item('db_data', 'db_data')
root_password = data['service_initial_root_password']
root_user = data['root_user']
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

execute 'sudo yum -y update' do
  command 'sudo yum -y update'
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
  #not_if "sudo mysql  -e \"SELECT User FROM mysql.user as us where us.user = 'Pregnant_Admin'\""
end

execute 'Pregnant_Admin user grant privileges' do
  command "sudo mysql -e \"GRANT ALL PRIVILEGES ON pregnant_application. * TO '#{Pregnant_Admin}'@'localhost'\""
  action :nothing
end

database_schema = File.join(Chef::Config[:file_cache_path], '/db_row.sql')

execute 'import schema to pregnant_application' do
  command "sudo mysql -uroot  pregnant_application < #{database_schema}"
  not_if 'mysql -e "select * from pregnant_application.authorization"'
end

execute 'sudo yum -y install yum-utils' do
  command 'sudo yum -y install yum-utils'
  live_stream true
end

execute 'install ius' do
  command 'sudo yum -y install --skip-broken https://centos7.iuscommunity.org/ius-release.rpm'
  live_stream true
end

execute 'install python36u' do
  command 'sudo yum -y install python36u'
  live_stream true
end

execute 'install python36u-pip' do
  command 'sudo yum -y install python36u-pip'
  live_stream true
end

execute 'install mysql-connector==2.1.6' do
  command 'sudo pip3.6 install mysql-connector==2.1.6'
  live_stream true
end

execute 'install pyqt5' do
  command 'sudo pip3.6 install pyqt5'
  live_stream true
end

execute 'install gnome desktop' do
  command 'sudo yum -y groups install "GNOME Desktop"'
  live_stream true
end
