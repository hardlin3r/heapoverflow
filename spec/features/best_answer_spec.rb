require_relative "feature_helper"

feature 'User can choose best answer', %q{
Being an author of the question
I want to be able to choose the best answer
} do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question_with_lot_of_answers, user: user) }
  describe 'Authenticated user' do
    context 'chooses best answer for his question' do
      before do
        sign_in(user)
        visit question_path(question)
      end
      scenario 'user chooses the best answer', js: true do
        first('div.vote').click_link 'Accept answer'
        sleep 0.3
        within(first('div.vote')) { expect(page).to have_selector(:link_or_button, 'Best answer') }
      end
      scenario 'best answer should be the only one, and it should be at the top of all answers', js: true do
        first('div.vote').click_link('Accept answer')
        all('div.vote').last.click_link('Accept answer')
        visit question_path(question)
        expect(all('div.vote').first).to have_link 'Best answer'
        expect(all('div.vote').last).to have_link 'Accept answer'
      end
      scenario 'unselect best answer to his question', js: true do
        first('div.vote').click_link 'Accept answer'
        sleep 0.3
        first('div.vote').click_link 'Best answer'
        sleep 0.3
        expect(page).to_not have_link 'Best answer'
      end
    end

    context 'operates with other user\'s question' do
      before do
        sign_in(user2)
        visit question_path(question)
      end
      scenario 'cannot see Accept answer link' do
        expect(page).to_not have_link 'Accept answer'
      end
    end
  end
  describe 'Non-authenticated user' do
    scenario 'cannot see Accept answer link' do
      visit question_path(question)
      expect(page).to_not have_link 'Accept answer'
    end
  end
end
