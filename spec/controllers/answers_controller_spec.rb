require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let!(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do

    sign_in_user

    context 'with valid attributes' do


      it 'saves the new answer with correct question' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'saves the new answer with correct owner' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(@user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template 'create'
      end

    end

    context 'with invalid attributes' do

      it 'does not save the answer' do
        expect { post :create, answer: { body: nil }, question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, answer: { body: nil }, question_id: question, format: :js
        expect(response).to render_template 'create'
      end

    end

  end

  describe 'DELETE #destroy' do

    context 'Authenticated user' do

      sign_in_user

      context 'Author of answer' do

        let!(:my_answer) { create(:answer, user: @user) }

        it 'delete answer from the database' do
          expect { delete :destroy, question_id: my_answer.question, id: my_answer, format: :js }.to change(@user.answers, :count).by(-1)
        end

      end

      context 'Non-author of answer' do

        it 'cannot delete answer' do
          answer
          expect { delete :destroy, question_id: answer.question, id: answer, format: :js }.to_not change(Answer, :count)
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

  describe 'PATCH #update' do
    sign_in_user

    it 'assigns requested answer to @answer' do
      patch :update,id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, id: answer, question_id: question, answer: { body: 'new super body'}, format: :js
      answer.reload
      expect(answer.body).to eq "new super body"
    end

    it 'assigns the question' do
      patch :update, id: answer, question_id: question, answer: { body: 'new super body'}, format: :js
      expect(assigns(:question)).to eq question
    end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
    end
  end
  describe "PATCH #set_best" do
    context "Authenticated user" do
      sign_in_user
      context "sets answer for his own question" do
        let!(:my_question) { create(:question, user: @user) }
        let!(:answer) { create(:answer, question: my_question, user: user)}
        let!(:another_answer) { create(:answer, question: my_question, user: user) }
        it 'assigns requested answer to @answer' do
          patch :set_best, question_id: my_question, id: answer, format: :js
          expect(assigns(:answer)).to eq answer
        end
        it 'sets best answer' do
          patch :set_best, question_id: my_question, id: answer, format: :js
          answer.reload
          expect(answer.best).to eq true
        end
        it 'best answer is the only one' do
          patch :set_best, question_id: my_question, id: another_answer, format: :js
          answer.reload
          another_answer.reload
          expect(answer.best).to eq false
          expect(another_answer.best).to eq true
        end
        it 're-renders answer set_best view' do
          patch :set_best, question_id: my_question, id: another_answer, format: :js
          expect(response).to render_template 'set_best'
        end
      end
    end

  end

end
