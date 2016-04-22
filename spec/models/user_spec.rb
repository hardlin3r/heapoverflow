require 'rails_helper'

RSpec.describe User do

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should have_many(:votes), dependent: :destroy }
  it { should have_many(:authorizations).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:answer2) { create(:answer, question: question, user: user) }
  let(:attachment) { create(:attachment, attachable: question) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do

      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do

      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect{User.find_for_oauth(auth)}.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect{User.find_for_oauth(auth)}.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end

      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com'}) }

        it 'creates new user' do
          expect{User.find_for_oauth(auth)}.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'sets user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

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

