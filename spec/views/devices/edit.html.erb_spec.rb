require 'spec_helper'

describe "devices/edit" do
  before(:each) do
    @device = assign(:device, stub_model(Device,
      :name => "MyString",
      :user_id => 1,
      :hardware_id => "MyString",
      :activation_token => "MyString"
    ))
  end

  it "renders the edit device form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", device_path(@device), "post" do
      assert_select "input#device_name[name=?]", "device[name]"
      assert_select "input#device_user_id[name=?]", "device[user_id]"
      assert_select "input#device_hardware_id[name=?]", "device[hardware_id]"
      assert_select "input#device_activation_token[name=?]", "device[activation_token]"
    end
  end
end
