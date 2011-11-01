require 'spec_helper'

describe "NetworkManager::DBus::Settings" do
  before :each do
    @data = fixture('settings.yml')
    @object_paths = object_paths_from_fixture('settings.yml')
  end
  
  it "should list properties" do
    network_manager_dbus_mock
    NetworkManager::DBus::Settings.instance.properties.should ==
      @data.first.last['properties']
  end
  
  it "should list connections" do
    network_manager_dbus_mock
    NetworkManager::DBus::Settings.connections.size.should == 1
  end
  
  describe 'hostname' do
    after :each do
      network_manager_dbus_mock
    end
    
    it 'should get hostname from properties' do
      network_manager_dbus_mock
      NetworkManager::DBus::Settings.instance.hostname.should ==
        @data.first.last['properties']['Hostname']
    end
    
    it 'should set hostname via object.SaveHostname' do
      network_manager_dbus_mock
      
      # manual spy
      new_hostname = nil
      subject = NetworkManager::DBus::Settings.instance.object
      stub(subject).SaveHostname { |h| new_hostname = h; new_hostname }
      
      # action
      NetworkManager::DBus::Settings.instance.hostname = 'a-host-name'
      
      # assert
      new_hostname.should == 'a-host-name'
    end
  end
end