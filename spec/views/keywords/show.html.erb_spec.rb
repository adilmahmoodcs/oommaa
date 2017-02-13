require 'rails_helper'

RSpec.describe "keywords/show", type: :view do
  before(:each) do
    @keyword = assign(:keyword, Keyword.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
