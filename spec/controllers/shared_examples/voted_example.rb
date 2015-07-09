require 'rails_helper'

RSpec.shared_examples "voted" do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:votable_name) { described_class.controller_name.singularize.underscore }
  let(:votable) { create(votable_name, user: user) }

  describe "POST #vote_up" do
    context 'non-authenticated user' do
      it "not change votes_sum" do
        expect{ post :vote_up, id: votable, format: :js }.to_not change(Vote, :count)
      end

      it "response status error 401" do
        post :vote_up, id: votable, format: :js
        expect(response.status).to eq(401)
      end
    end

    context 'authenticated user like owner voted post' do
      sign_in_user

      it "not change votes_sum" do
        expect{ post :vote_up, id: votable, format: :js }.to_not change(Vote, :count)
      end

      it "redirect to root path" do
        post :vote_up, id: votable, format: :js
        expect(response.status).to eq(422)
      end
    end

    context 'another authenticated user' do
      sign_in_another_user

      it 'add vote to database' do
        expect { patch :vote_up, id: votable, format: :json }.to change(Vote, :count).by(1)
      end

      it "change votes_sum" do
        expect{ post :vote_up, id: votable, format: :js }.to change{ votable.votes_sum }.from(0).to(1)
      end

      it "render json success" do
        post :vote_up, id: votable, format: :js
        expect(response).to be_success
      end
    end

    context 'another authenticated user voting multiple times' do
      sign_in_another_user
      before { patch :vote_up, id: votable, format: :json }

      it 'does not save second vote in database' do
        expect { patch :vote_up, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'responds with error' do
        patch :vote_up, id: votable, format: :json
        expect(response.status).to eq(422)
      end
    end
  end

  describe "POST #vote_down" do
    context 'non-authenticated user' do
      it "not change votes_sum" do
        expect{ post :vote_down, id: votable, format: :js }.to_not change(Vote, :count)
      end

      it "response status error 401" do
        post :vote_down, id: votable, format: :js
        expect(response.status).to eq(401)
      end
    end

    context 'authenticated user like owner voted post' do
      sign_in_user

      it "not change votes_sum" do
        expect{ post :vote_down, id: votable, format: :js }.to_not change(Vote, :count)
      end

      it "redirect to root path" do
        post :vote_down, id: votable, format: :js
        expect(response.status).to eq(422)
      end
    end

    context 'another authenticated user' do
      sign_in_another_user

      it 'add vote to database' do
        expect { patch :vote_down, id: votable, format: :json }.to change(Vote, :count).by(1)
      end

      it "change votes_sum" do
        expect{ post :vote_down, id: votable, format: :js }.to change{ votable.votes_sum }.from(0).to(-1)
      end

      it "render json success" do
        post :vote_down, id: votable, format: :js
        expect(response).to be_success
      end
    end

    context 'another authenticated user voting multiple times' do
      sign_in_another_user
      before { patch :vote_down, id: votable, format: :json }

      it 'does not save second vote in database' do
        expect { patch :vote_down, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'responds with error' do
        patch :vote_down, id: votable, format: :json
        expect(response.status).to eq(422)
      end
    end
  end

  describe "DELETE #cancel_vote" do
    let!(:vote) { create(:vote, user: another_user, votable: votable) }

    context 'with user has vote' do
      sign_in_another_user

      it 'removes vote from database' do
        expect { patch :cancel_vote, id: votable, format: :json }.to change(Vote, :count).by(-1)
      end

      it 'changes votes_sum' do
        expect { patch :cancel_vote, id: votable, format: :json }.to change{ votable.votes_sum }.from(1).to(0)
      end

      it 'responds with success' do
        patch :cancel_vote, id: votable, format: :json
        expect(response).to be_success
      end
    end

    context 'without user has vote' do
      sign_in_user
      it 'does not delete any vote from database' do
        expect { patch :cancel_vote, id: votable, format: :json }.to_not change(Vote, :count)
      end

      it 'responds with error' do
        patch :cancel_vote, id: votable, format: :json
        expect(response.status).to eq(422)
      end
    end
  end

end