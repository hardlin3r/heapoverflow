require 'rails_helper'

describe AnswersController do
  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:answer) { create :answer, user: user }
  let(:question) { create :question, user: user }

  describe 'PATCH #upvote' do
    context 'votes up for his own answer' do
      before { sign_in(user) }
      it '- does not keep the vote' do
        expect { patch :upvote, question_id: question, id: answer, format: :json }.to_not change(answer.votes.upvotes, :count)
        expect { patch :upvote, question_id: question, id: answer, format: :json }.to_not change(answer.votes.upvotes, :size)
      end
    end

    context "votes up for other user's answer" do
      before { sign_in(another_user) }
      it "- keep's the vote" do
        expect { patch :upvote, question_id: question, id: answer, format: :json }.to change(answer.votes.upvotes, :count).by 1
      end
    end
  end

  describe 'PATCH #downvote' do
    context 'votes down for his own answer' do
      before { sign_in(user) }
      it '- does not keep the vote' do
        expect { patch :downvote, question_id: question, id: answer, format: :json }.to_not change(answer.votes.downvotes, :count)
      end
    end

    context "votes down for other user's answer" do
      before { sign_in(another_user) }
      it "- keep's the vote" do
        expect { patch :downvote, question_id: question, id: answer, format: :json }.to change(answer.votes.downvotes, :count).by 1
      end
    end
  end

  describe 'PATCH #unvote' do
    before do
      sign_in(another_user)
      patch :upvote, question_id: question, id: answer, format: :json
    end

    it '- deletes vote for votable object (answer)' do
      expect { patch :unvote, question_id: question, id: answer, format: :json }.to change(answer.votes, :count).by(-1)
    end
  end
end


describe QuestionsController do
  let(:user) { create :user }
  let(:another_user) { create :user }
  let(:question) { create :question, user: user }

  describe 'PATCH #upvote' do
    context 'votes up for his own question' do
      before { sign_in(user) }
      it '- does not keep the vote' do
        expect { patch :upvote, id: question, format: :json }.to_not change(question.votes.upvotes, :count)
        expect { patch :upvote, id: question, format: :json }.to_not change(question.votes.upvotes, :size)
      end
    end

    context "votes up for other user's question" do
      before { sign_in(another_user) }
      it "- keep's the vote" do
        expect { patch :upvote, id: question, format: :json }.to change(question.votes.upvotes, :count).by 1
      end
    end
  end

  describe 'PATCH #downvote' do
    context 'votes down for his own question' do
      before { sign_in(user) }
      it '- does not keep the vote' do
        expect { patch :downvote, id: question, format: :json }.to_not change(question.votes.downvotes, :count)
      end
    end

    context "votes down for other user's question" do
      before { sign_in(another_user) }
      it "- keep's the vote" do
        expect { patch :downvote, id: question, format: :json }.to change(question.votes.downvotes, :count).by 1
      end
    end
  end

  describe 'PATCH #unvote' do
    before do
      sign_in(another_user)
      patch :upvote, id: question, format: :json
    end

    it '- deletes vote for votable object (question)' do
      expect { patch :unvote, id: question, format: :json }.to change(question.votes, :count).by(-1)
    end
  end

end
