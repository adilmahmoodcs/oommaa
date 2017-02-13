require 'rails_helper'

RSpec.describe "keywords/edit", type: :view do
  before(:each) do
    @keyword = assign(:keyword, Keyword.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit keyword form" do
    render

    assert_select "form[action=?][method=?]", keyword_path(@keyword), "post" do

      assert_select "input#keyword_name[name=?]", "keyword[name]"
    end
  end
end
