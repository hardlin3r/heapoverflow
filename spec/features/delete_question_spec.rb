require 'rails_helper'

feature 'delete question', %q{
In order to delete question
As an author of the question
I can delete the quesiton
} do

  given!(:question) { create(:question)}
  given(:user) { create(:user) }

  scenario 'delete as author' do
    sign_in(question.user)
    visit question_url(question)
    click_on 'Delete this question'
    expect(page).to have_content 'Question was deleted successfully'
    expect(page).to_not have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'delete as non-author' do
    sign_in(user)
    visit question_url(question)
    expect(page).to_not have_link('Delete this question')
  end

end
