require 'rails_helper'

feature 'delete answer', %q{
As an author
I want to delete my answer
} do

  given!(:answer) { create(:answer) }
  given(:user) { create(:user) }

  scenario 'author deletes answer' do
    sign_in(answer.user)
    visit question_url(answer.question)
    click_on 'Delete'
    expect(page).to have_content 'Your answer was deleted successfully'
    expect(page).to_not have_content answer.body
  end

  scenario 'non-author doesnt see delete link' do
    sign_in(user)
    visit question_url(answer.question)
    expect(page).to_not have_link('Delete')
  end

end
