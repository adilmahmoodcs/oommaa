require 'rails_helper'

RSpec.describe "keywords/index", type: :view do
  before(:each) do
    assign(:keywords, [
      Keyword.create!(
        :name => "Name"
      ),
      Keyword.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of keywords" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
