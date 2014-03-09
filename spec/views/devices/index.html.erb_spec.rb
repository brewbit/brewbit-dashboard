require 'spec_helper'

describe "devices/index" do
  before(:each) do
    assign(:devices, [
      stub_model(Device,
        :name => "Name",
        :user_id => 1,
        :hardware_id => "Hardware",
        :activation_token => "Activation Token"
      ),
      stub_model(Device,
        :name => "Name",
        :user_id => 1,
        :hardware_id => "Hardware",
        :activation_token => "Activation Token"
      )
    ])
  end

  it "renders a list of devices" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Hardware".to_s, :count => 2
    assert_select "tr>td", :text => "Activation Token".to_s, :count => 2
  end
end
