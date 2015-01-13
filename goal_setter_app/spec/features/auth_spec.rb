require 'spec_helper'
require 'rails_helper'

feature "the signup process" do

  scenario "has a new user page" do
    visit new_user_url
    expect(page).to have_content "New user"
  end

end

feature "signing up a user" do

  scenario "shows username on the homepage after signup" do
    visit new_user_url
    user = build(:user)
    fill_in ('Username'), with: user.username
    fill_in ('Password'), with: user.password
    click_on "Create User!"
    expect(page).to have_content "Welcome, #{user.username}!"
  end
end

feature "logging in" do

  scenario "has a login page" do
    visit new_session_url
    #save_and_open_page
    expect(page).to have_content "Log In"
  end

  scenario "shows username on the homepage after login" do
    user = login_test_user
    expect(page).to have_content "Welcome back, #{user.username}"
  end
end

feature "logging out" do

  scenario "begins with logged out state" do
    visit new_session_url
    expect(page).to_not have_content "Logged in as"
  end

  scenario "doesn't show username on the homepage after logout" do
    visit new_session_url
    user = create(:user)
    fill_in ('Username'), with: user.username
    fill_in ('Password'), with: user.password
    click_on "Log In!"
    click_on "Log Out!"
    expect(page).to_not have_content "#{user.username}"
  end

end
