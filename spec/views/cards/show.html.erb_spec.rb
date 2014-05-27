require 'spec_helper'

describe "cards/show" do
  before(:each) do
    @card = assign(:card, stub_model(Card,
      :card_id => "Card",
      :name => "Name",
      :name_yomi => "Name Yomi",
      :rare => 1,
      :kind => 2,
      :type => 3,
      :color => 4,
      :level => 5,
      :grow_cost => "Grow Cost",
      :cost => "Cost",
      :limit => 6,
      :power => 7,
      :condition => "Condition",
      :guard => 8,
      :card_text => "Card Text",
      :life_burst => "Life Burst",
      :view_text => "View Text"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Card/)
    rendered.should match(/Name/)
    rendered.should match(/Name Yomi/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/5/)
    rendered.should match(/Grow Cost/)
    rendered.should match(/Cost/)
    rendered.should match(/6/)
    rendered.should match(/7/)
    rendered.should match(/Condition/)
    rendered.should match(/8/)
    rendered.should match(/Card Text/)
    rendered.should match(/Life Burst/)
    rendered.should match(/View Text/)
  end
end
