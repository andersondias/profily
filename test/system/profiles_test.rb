require "application_system_test_case"

class ProfilesTest < ApplicationSystemTestCase
  setup do
    @profile = profiles(:one)
  end

  test "visiting the index" do
    visit profiles_url
    assert_selector "h1", text: "Profiles"
  end

  test "creating a Profile" do
    visit profiles_url
    click_on "New Profile"

    fill_in "Country", with: @profile.country
    fill_in "First name", with: @profile.first_name
    fill_in "Headline", with: @profile.headline
    fill_in "Last name", with: @profile.last_name
    fill_in "Location", with: @profile.location
    click_on "Create Profile"

    assert_text "Profile was successfully created"
    click_on "Back"
  end

  test "updating a Profile" do
    visit profiles_url
    click_on "Edit", match: :first

    fill_in "Country", with: @profile.country
    fill_in "First name", with: @profile.first_name
    fill_in "Headline", with: @profile.headline
    fill_in "Last name", with: @profile.last_name
    fill_in "Location", with: @profile.location
    click_on "Update Profile"

    assert_text "Profile was successfully updated"
    click_on "Back"
  end

  test "saving a draft version of Profile" do
    visit profiles_url
    click_on "Edit", match: :first

    fill_in "Country", with: 'New Country'
    fill_in "First name", with: 'First'
    fill_in "Headline", with: 'New headline'
    fill_in "Last name", with: 'Last'
    fill_in "Location", with: 'New city'
    click_on "Save Draft"

    assert_text "There is a draft version available in edit mode"
    click_on "Back"
  end

  test "destroying a Profile" do
    visit profiles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Profile was successfully destroyed"
  end
end
