require 'spec_helper'

describe "cards/edit" do
  before(:each) do
    @card = assign(:card, stub_model(Card,
      :card_id => "MyString",
      :name => "MyString",
      :name_yomi => "MyString",
      :rare => 1,
      :kind => 1,
      :type => 1,
      :color => 1,
      :level => 1,
      :grow_cost => "MyString",
      :cost => "MyString",
      :limit => 1,
      :power => 1,
      :condition => "MyString",
      :guard => 1,
      :card_text => "MyString",
      :life_burst => "MyString",
      :view_text => "MyString"
    ))
  end

  it "renders the edit card form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", card_path(@card), "post" do
      assert_select "input#card_card_id[name=?]", "card[card_id]"
      assert_select "input#card_name[name=?]", "card[name]"
      assert_select "input#card_name_yomi[name=?]", "card[name_yomi]"
      assert_select "input#card_rare[name=?]", "card[rare]"
      assert_select "input#card_kind[name=?]", "card[kind]"
      assert_select "input#card_type[name=?]", "card[type]"
      assert_select "input#card_color[name=?]", "card[color]"
      assert_select "input#card_level[name=?]", "card[level]"
      assert_select "input#card_grow_cost[name=?]", "card[grow_cost]"
      assert_select "input#card_cost[name=?]", "card[cost]"
      assert_select "input#card_limit[name=?]", "card[limit]"
      assert_select "input#card_power[name=?]", "card[power]"
      assert_select "input#card_condition[name=?]", "card[condition]"
      assert_select "input#card_guard[name=?]", "card[guard]"
      assert_select "input#card_card_text[name=?]", "card[card_text]"
      assert_select "input#card_life_burst[name=?]", "card[life_burst]"
      assert_select "input#card_view_text[name=?]", "card[view_text]"
    end
  end
end
