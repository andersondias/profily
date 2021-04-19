# == Schema Information
#
# Table name: profiles
#
#  id                  :bigint           not null, primary key
#  country             :string(60)       not null
#  first_name          :string(60)       not null
#  headline            :string(200)      not null
#  last_name           :string(60)       not null
#  location            :string(100)      not null
#  slug                :string(100)      not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  original_profile_id :bigint
#
# Indexes
#
#  index_profiles_on_original_profile_id  (original_profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (original_profile_id => profiles.id)
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
      should_not allow_value('anderson-days').for(:slug).on(:update)

      context 'with draft' do
        subject { profiles(:two) }

        should allow_value('anderson-days').for(:slug).on(:update)
        should allow_value('anderson-days-123').for(:slug).on(:update)
        should_not allow_value('anderson-dias').for(:slug).on(:update)
      end

      context 'draft' do
        subject { profiles(:draft) }

        should allow_value('anderson-123').for(:slug).on(:update)
        should allow_value('anderson-days').for(:slug).on(:update)
        should_not allow_value('anderson-dias').for(:slug).on(:update)
      end
    end
  end

  context 'slug' do
    should 'generate based on first and last name when creating a record' do
      profile = Profile.new(first_name: 'Anderson', last_name: 'Ferreira',
                            headline: 'abc', country: 'AB', location: 'BC')
      profile.save!
      assert profile.slug.start_with?('anderson-ferreira-')
      assert_match /\d-\d+\z/, profile.slug
    end

    should 'setup based on original profile for draft records' do
      original = profiles(:one)
      draft = original.create_draft!(first_name: 'Test', last_name: 'Test',
                                     headline: 'abc', country: 'BC', location: 'DC')
      assert_equal original.slug, draft.slug
    end

    should 'respect given slug for draft records' do
      original = profiles(:one)
      draft = original.create_draft!(slug: 'draft-slug',
                                     first_name: 'Test', last_name: 'Test',
                                     headline: 'abc', country: 'BC', location: 'DC')
      assert_equal 'draft-slug', draft.slug
    end
  end

  context 'after update' do
    should 'delete associated draft post' do
      original = profiles(:two)
      assert original.draft.present?

      original.update!(first_name: 'Another')

      refute original.reload.draft.present?
    end
  end
end
