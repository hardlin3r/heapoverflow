require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:question_with_answers) { create(:question_with_answers) }
  let(:answer) { create(:answer) }
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        id = question_with_answers.id
        expect { post :create, answer: attributes_for(:answer), question_id: id }.to change(Answer, :count).by(1)
      end

      it 'redirects to question view' do
        post :create, answer: attributes_for(:answer), question_id: question_with_answers
        expect(response).to redirect_to question_path(question_with_answers)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        id = question_with_answers.id
        expect { post :create, answer: { body: nil }, question_id: id }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        post :create, answer: { body: nil }, question_id: question_with_answers
        expect(response).to redirect_to question_path(question_with_answers)
      end
    end
  end

end
