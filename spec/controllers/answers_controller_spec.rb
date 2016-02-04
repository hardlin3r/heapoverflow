require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do

    context 'with valid attributes' do

      sign_in_user

      it 'saves the new answer with correct question' do
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(question.answers, :count).by(1)
      end

      it 'saves the new answer with correct owner' do
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(@user.answers, :count).by(1)
      end

      it 'redirects to question view' do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question_path(question)
      end

    end

    context 'with invalid attributes' do

      it 'does not save the answer' do
        expect { post :create, answer: { body: nil }, question_id: question }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        post :create, answer: { body: nil }, question_id: question
        expect(response).to redirect_to new_user_session_url
      end

    end

  end

  describe 'DELETE #destroy' do

    context 'Authenticated user' do

      sign_in_user

      context 'Author of answer' do

        let!(:my_answer) { create(:answer, user: @user) }

        it 'delete answer from the database' do
          expect { delete :destroy, question_id: my_answer.question, id: my_answer }.to change(@user.answers, :count).by(-1)
        end

        it 'redirects to question view' do
          delete :destroy, question_id: my_answer.question, id: my_answer
          expect(response).to redirect_to question_path(my_answer.question)
        end

      end

      context 'Non-author of answer' do

        it 'cannot delete answer' do
          answer
          expect { delete :destroy, question_id: answer.question, id: answer }.to_not change(Answer, :count)
        end

        it 'redirects to question view' do
          delete :destroy, question_id: answer.question, id: answer
          expect(response).to redirect_to question_path(answer.question)
        end

      end

    end

    context 'Non-authenticated user' do

      it "redirects to login page" do
        answer
        delete :destroy, question_id: answer.question, id: answer
        expect(response).to redirect_to new_user_session_url
      end

    end

   end

end
