require 'rails_helper'

describe QuestionsController, type: :controller do

  let(:question) { create(:question) }

  describe "GET #index" do

    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates and array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end

  end

  describe "GET #show" do

    before { get :show, id: question }

    it 'assigns requested queston to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

  end

  describe "GET #new" do

   sign_in_user
   before { get :new }

    it 'assign new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders a new view' do
      expect(response).to render_template :new
    end

  end

  describe 'GET #edit' do

    sign_in_user
    before { get :edit, id: question }

    it 'assigns requested queston to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders a edit view' do
      expect(response).to render_template :edit
    end

  end

  describe 'POST #create' do

    sign_in_user

    context 'with valid attributes' do

      it 'saves the new question with valid user' do
        expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

    end

    context 'with invalid attributes' do

      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end

    end

  end

  describe 'PATCH #update' do

    sign_in_user
    let(:question) { create(:question, user_id: @user.id)}
    context 'valid attributes' do

      it 'assigns requested queston to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: "new super puper title", body: "new super puper body" }, format: :js
        question.reload
        expect(question.title).to eq "new super puper title"
        expect(question.body).to eq "new super puper body"
      end

      it 'render update template' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end

    end

    context 'invalid attributes' do

      before { patch :update, id: question, question: { title: "new super puper title", body: nil}, format: :js }

      it 'does not change question attributes' do
        title = question.title
        body = question.body
        question.reload
        expect(question.title).to eq title
        expect(question.body).to eq body
      end

    end

  end

  describe 'DELETE #destroy' do

    before { question }

    context 'signed in' do

      sign_in_user

      context 'own question' do

        let!(:my_question) { create(:question, user: @user) }

        it 'deletes question' do
          expect { delete :destroy, id: my_question }.to change(Question, :count).by(-1)
        end

        it 'redirects to index view' do
          delete :destroy, id: my_question
          expect(response).to redirect_to questions_path
        end

      end

      context 'another user\'s question' do

        it 'deletes question' do
          expect { delete :destroy, id: question }.to_not change(Question, :count)
        end

        it 'redirects to not deleted question' do
          delete :destroy, id: question
          expect(response).to redirect_to question_url(question)
        end

     end

    end

    context 'Non-author of the question' do

      it "redirects to login page" do
        delete :destroy, id: question
        expect(response).to redirect_to new_user_session_url
      end

    end
  end

end
