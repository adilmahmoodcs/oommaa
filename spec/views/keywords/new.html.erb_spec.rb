require 'rails_helper'

RSpec.describe "keywords/new", type: :view do
  before(:each) do
    assign(:keyword, Keyword.new(
      :name => "MyString"
    ))
  end

  it "renders new keyword form" do
    render

    assert_select "form[action=?][method=?]", keywords_path, "post" do

      assert_select "input#keyword_name[name=?]", "keyword[name]"
    end
  end
end
