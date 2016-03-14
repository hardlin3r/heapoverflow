require 'rails_helper'

RSpec.describe User do

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should have_many(:votes), dependent: :destroy }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:answer2) { create(:answer, question: question, user: user) }
  let(:attachment) { create(:attachment, attachable: question) }

  describe '#author_of?' do

    it 'question author_of?' do
      expect(user.author_of?(question)).to be_truthy
    end

    it 'answer author_of?' do
      expect(user.author_of?(answer)).to be_truthy
    end

    it 'attachment author_of?' do
      expect(user.author_of?(attachment.attachable)).to be_truthy
    end

  end

  describe '#upvote_for answer' do
    it 'upvote by 1' do
      expect{ user.vote_for(answer, 1) }.to change(answer.votes.upvotes, :count).by(1)
    end
  end

  describe '#downvote_for answer' do
    it 'downvote by 1' do
      expect{ user.vote_for(answer, -1) }.to change(answer.votes.downvotes, :count).by(1)
    end
  end

  describe '#voted_for?' do
    it 'voted_for? answer ' do
      user.vote_for(answer, 1)
      expect(user.voted_for?(answer)).to be_truthy
    end

    it 'voted_for? answer2 ' do
      user.vote_for(answer2, 1)
      expect(user.voted_for?(answer)).to be_falsy
    end
  end

  describe '#unvote_for' do
    it 'resets vote for answer' do
      user.vote_for(answer, 1)
      expect{ user.unvote_for(answer) }.to change(answer.votes.upvotes, :count).by(-1)
    end
  end
end

