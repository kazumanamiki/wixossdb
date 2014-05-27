require 'spec_helper'

describe "cards/index" do
  before(:each) do
    assign(:cards, [
      stub_model(Card,
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
      ),
      stub_model(Card,
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
      )
    ])
  end

  it "renders a list of cards" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Card".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Name Yomi".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "Grow Cost".to_s, :count => 2
    assert_select "tr>td", :text => "Cost".to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => "Condition".to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => "Card Text".to_s, :count => 2
    assert_select "tr>td", :text => "Life Burst".to_s, :count => 2
    assert_select "tr>td", :text => "View Text".to_s, :count => 2
  end
end
