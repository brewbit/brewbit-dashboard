require 'spec_helper'

describe "devices/new" do
  before(:each) do
    assign(:device, stub_model(Device,
      :name => "MyString",
      :user_id => 1,
      :hardware_id => "MyString",
      :activation_token => "MyString"
    ).as_new_record)
  end

  it "renders new device form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", devices_path, "post" do
      assert_select "input#device_name[name=?]", "device[name]"
      assert_select "input#device_user_id[name=?]", "device[user_id]"
      assert_select "input#device_hardware_id[name=?]", "device[hardware_id]"
      assert_select "input#device_activation_token[name=?]", "device[activation_token]"
    end
  end
end
