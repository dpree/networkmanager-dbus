require 'spec_helper'

describe "NetworkManager::DBus::SettingsConnection" do
  before :each do
    @data = fixture('settings_connections.yml')
    @object_paths = object_paths_from_fixture('settings_connections.yml')
  end
  
  it "should have no properties" do
    network_manager_dbus_mock
    con = NetworkManager::DBus::SettingsConnection.new @object_paths.first
    con.properties.should == nil
  end
  
  it "should get settings" do
    network_manager_dbus_mock
    con = NetworkManager::DBus::SettingsConnection.new @object_paths.first
    con.settings.should == @data.first.last['settings']
  end
  
  it 'should get secrets' do
    network_manager_dbus_mock
    con = NetworkManager::DBus::SettingsConnection.new @object_paths.first
    lambda do
      con.secrets
    end.should raise_error(NetworkManager::DBus::SettingsConnection::SecretsCacheInvalidError)
  end
  
  describe 'update' do
    it 'should do update' do
      network_manager_dbus_mock
      con = NetworkManager::DBus::SettingsConnection.new @object_paths.first
      hash = con.settings.dup
      hash['connection']['id'] = 'bar'
      con.update hash
      con.settings['connection']['id'].should == 'bar'
    end
  
    it 'should get #name' do
      network_manager_dbus_mock
      con = NetworkManager::DBus::SettingsConnection.new @object_paths.first
      con.name.should == 'Wired connection 1'
    end
  
    it 'should set #name=' do
      network_manager_dbus_mock
      con = NetworkManager::DBus::SettingsConnection.new @object_paths.first
      con.name = 'foo'
      con.name.should == 'foo'
    end
  end
end
