require 'spec_helper'
require 'rails_helper'

feature 'the goal creation process' do
  before(:each) do
    login_test_user
  end

  scenario 'user can create goal from their show page' do
    expect(page).to have_button("Add New Goal")
  end

  scenario 'new goal is added to users show page' do
    goal = build(:goal)
    fill_in ('Title'), with: goal.title
    fill_in ('Description'), with: goal.description
    click_on "Add New Goal"
    expect(page).to have_link("#{goal.title}")
  end
end

feature 'public/private functionality' do

  scenario 'current user can see all of their own posts' do
    current_user = login_test_user
    private_goal = test_goal_private(current_user)
    public_goal = test_goal_public(current_user)

    visit user_url(current_user)
    expect(page).to have_content("#{private_goal.title}")
    expect(page).to have_content("#{public_goal.title}")
  end

  scenario "current user cannot see another user's private posts" do
    other_user = login_test_user
    private_goal = test_goal_private(other_user)
    public_goal = test_goal_public(other_user)
    click_on "Log Out!"
    current_user = login_test_user
    visit user_url(other_user)
    expect(page).to_not have_content("#{private_goal.title}")
  end

  scenario "current user can see another users' public posts" do
    other_user = login_test_user
    private_goal = test_goal_private(other_user)
    public_goal = test_goal_public(other_user)
    click_on "Log Out!"
    current_user = login_test_user
    visit user_url(other_user)
    expect(page).to have_content("#{public_goal.title}")
  end
end

feature 'goal completion process' do

  scenario 'goal starts out incomplete' do
    user = login_test_user
    goal = test_goal_public(user)
    visit user_url(user)

    expect(page).to have_content("#{goal.title}, Incomplete")
  end

  scenario 'goal can be completed from the goal show page' do
    user = login_test_user
    goal = test_goal_public(user)
    visit goal_url(goal)

    expect(page).to have_button("Check Complete!")
  end
end
