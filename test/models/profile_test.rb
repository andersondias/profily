# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  country    :string(60)       not null
#  first_name :string(60)       not null
#  headline   :string(200)      not null
#  last_name  :string(60)       not null
#  location   :string(100)      not null
#  slug       :string(100)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  context 'validations' do
    should validate_presence_of(:first_name)
    should validate_presence_of(:last_name)
    should validate_presence_of(:country)
    should validate_presence_of(:location)
    should validate_presence_of(:slug).on(:update)
    should validate_uniqueness_of(:slug).on(:update)

    context 'slug update' do
      subject { profiles(:one) }

      should allow_value('anderson-another').for(:slug).on(:update)
      should allow_value('anderson-another-123').for(:slug).on(:update)
      should allow_value('anderson-123-other').for(:slug).on(:update)
      should_not allow_value('anderson-#$').for(:slug).on(:update)
      should_not allow_value('anderson dias').for(:slug).on(:update)
    end
  end
end
