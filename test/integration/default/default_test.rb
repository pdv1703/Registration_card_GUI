require 'inspec'

describe file('/home/vagrant/HistoryStatistic.py') do
 it { should exist }
end

describe yum do
  its('epel') { should exist }
  its('epel') { should be_enabled }
end

describe package('yum-utils') do
  it { should be_installed }
end

describe package('epel-release') do
  it { should be_installed }
end

describe package('python36u') do
  it { should be_installed }
end

describe package('python36u-pip') do
  it { should be_installed }
end

describe service('mysql') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe command("yum grouplist | sed '/^Installed Environment Groups:/,$!d;/^Installed Groups:/,$d;/^Available Environment Groups:/,$d;/^Installed Environment Groups:/d;s/^[[:space:]]*//' | grep 'GNOME Desktop'") do
  its('stdout') { should eq "GNOME Desktop\n" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

# describe command('echo hello') do
#   its('stdout') { should eq "hello\n" }
#   its('stderr') { should eq '' }
#   its('exit_status') { should eq 0 }
# end
