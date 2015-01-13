require 'spec_helper'
require 'rails_helper'

feature 'can comment on a goal' do

  scenario "can comment on user's own goal" do
    user = login_test_user
    goal = test_goal_public(user)
    visit goal_url(goal)
    comment = build(:comment)
    fill_in ('Comment'), with: comment.body
    click_on "Add Comment!"
    expect(page).to have_content("#{comment.body}")
  end

  scenario "can comment on another user's goal" do
    other_user = login_test_user
    goal = test_goal_public(other_user)
    click_on "Log Out!"
    current_user = login_test_user
    visit goal_url(goal)
    comment = build(:comment)
    fill_in ('Comment'), with: comment.body
    click_on "Add Comment!"
    expect(page).to have_content("#{comment.body}")
  end

end

feature 'can comment on a user' do

  scenario "can comment on oneself" do
    user = login_test_user
    comment = build(:comment)
    fill_in ('Comment'), with: comment.body
    click_on "Add Comment!"
    expect(page).to have_content("#{comment.body}")
  end

  scenario "can comment (and judge) someone else" do
    other_user = login_test_user
    click_on "Log Out!"
    current_user = login_test_user
    visit user_url(other_user)
    comment = build(:comment)
    fill_in ('Comment'), with: comment.body
    click_on "Add Comment!"
    expect(page).to have_content("#{comment.body}")
  end
end
