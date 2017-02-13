require 'rails_helper'

RSpec.describe FacebookPost, type: :model do
  it { is_expected.to define_enum_for(:status) }
end
