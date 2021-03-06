require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile = profiles(:one)
  end

  test "should get index" do
    get profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_profile_url
    assert_response :success
  end

  test "should create profile" do
    assert_difference('Profile.count') do
      post profiles_url, params: { profile: { country: @profile.country, first_name: @profile.first_name, headline: @profile.headline, last_name: @profile.last_name, location: @profile.location } }
    end

    assert_redirected_to profile_url(Profile.last)
  end

  test "should show profile" do
    get profile_url(@profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_url(@profile)
    assert_response :success
  end

  test "should update profile" do
    patch profile_url(@profile), params: { profile: { country: @profile.country, first_name: @profile.first_name, headline: @profile.headline, last_name: @profile.last_name, location: @profile.location } }
    assert_redirected_to profile_url(@profile)
  end

  test "should update profile as draft" do
    assert_difference('Profile.drafts.count') do
      assert_no_difference('Profile.count') do
        patch profile_url(@profile), params: { profile: { country: @profile.country, first_name: @profile.first_name, headline: @profile.headline, last_name: @profile.last_name, location: @profile.location }, commit: 'draft'}
      end
    end

    assert_equal @profile, Profile.drafts.last.original_profile
    assert_equal @profile, @profile.reload

    assert_redirected_to profile_url(@profile)
  end

  test "should destroy profile" do
    assert_difference('Profile.count', -1) do
      delete profile_url(@profile)
    end

    assert_redirected_to profiles_url
  end
end
