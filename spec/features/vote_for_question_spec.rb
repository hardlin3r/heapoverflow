require_relative 'feature_helper'

feature 'Vote for question', %q{
As a user
In order to know the question's rating
I want to be able to vote for question
} do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'Authenticated user' do

    context 'vote for his question' do

      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'cannot see upvote button' do
        within("#question-#{question.id}") do
         expect(page).to_not have_selector(:link_or_button, "Vote up")
        end
      end

      scenario 'cannot see downvote button' do
        within("#question-#{question.id}") do
          expect(page).to_not have_selector(:link_or_button, "Vote down")
        end
      end

    end

    context 'vote for other user\'s question' do

      before do
        sign_in(other_user)
        visit question_path(question)
      end

      scenario 'sees voting buttons vote up and down', js: true do
        within("#question-#{question.id}") do
          expect(page).to have_selector(:link_or_button, "Vote down")
          expect(page).to have_selector(:link_or_button, "Vote up")
        end
      end

      scenario 'can vote up', js: true do
        within("#question-#{question.id}") { find('a.vote-up').click }
        expect(page).to have_selector(:link_or_button, 'Unvote')
        expect(page).to have_content 1
      end

      scenario 'can vote down', js: true do
        within("#question-#{question.id}") { find('a.vote-down').click }
        expect(page).to have_selector(:link_or_button, 'Unvote')
        expect(page).to have_content -1
      end

      scenario 'cannot vote up twice', js: true do
        within("#question-#{question.id}") do
          find('a.vote-up').click
          expect(page).to_not have_selector(:link_or_button, 'Vote up')
          expect(page).to have_selector(:link_or_button, 'Unvote')
          expect(page).to have_content 1
        end
      end

      scenario 'cannot vote down twice', js: true do
        within("#question-#{question.id}") do
          find('a.vote-down').click
          expect(page).to_not have_selector(:link_or_button, 'Vote down')
          expect(page).to have_selector(:link_or_button, 'Unvote')
          expect(page).to have_content -1
        end
      end

      scenario 'can cancel his vote', js: true do

        within("#question-#{question.id}") do
          find('a.vote-down').click
          sleep 0.5
          find('a.vote-unvote').click
        end


        within("#question-#{question.id}") do
          expect(page).to have_selector(:link_or_button, 'Vote up')
          expect(page).to have_selector(:link_or_button, 'Vote down')
          expect(page).to have_content 0
        end
      end

      scenario 'voting change questions ranking', js: true do

        within("#question-#{question.id}") do
          find('a.vote-down').click
          expect(page).to have_selector(:link_or_button, 'Unvote')
          expect(page).to have_content -1
        end
      end
    end
  end
end
