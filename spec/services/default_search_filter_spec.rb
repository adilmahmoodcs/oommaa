require 'rails_helper'

RSpec.describe DefaultSearchFilter do
  subject { DefaultSearchFilter }
  let!(:brand1) { create(:brand, name: "First Name", nicknames: ["nick1", "nick-one"]) }
  let!(:brand2) { create(:brand, name: "Second Name", nicknames: ["nick2", "nick-two"]) }
  let!(:user) {create(:user, name: "TestUSer", email: "test@test.com", role: 2)}
  let!(:page) { create(:facebook_page, name: "first page") }
  let!(:page2) { create(:facebook_page, name: "second page") }
  let!(:licensor) {create(:licensor, name: "first licensor")}
  let!(:licensor2) {create(:licensor, name: "second licensor")}

  it "raise ArgumentError with missing arguments" do
    expect{subject.new}.to raise_error(ArgumentError)
    expect{subject.new(term: "first").call('Brand', user)}.to_not raise_error
  end

  it "Should give The same name as the term given" do
    expect(subject.new(term: "first").call('Brand', user)[:results][0][:text]).to eq(brand1.name)
    expect(subject.new(term: "first").call('Licensor', user)[:results][0][:text]).to eq(licensor.name)
    expect(subject.new(term: "first").call('FacebookPage', user)[:results][0][:text]).to eq(page.name)
  end

  it "Should give The same name as the id is  given" do
    expect(subject.new(term: {id: brand1.id}).call('Brand', user)[:results][0][:text]).to eq(brand1.name)
    expect(subject.new(term: {id: licensor.id}).call('Licensor', user)[:results][0][:text]).to eq(licensor.name)
    expect(subject.new(term: {id: page.id}).call('FacebookPage', user)[:results][0][:text]).to eq(page.name)
  end
end
