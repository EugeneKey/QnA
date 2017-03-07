# frozen_string_literal: true
RSpec.shared_examples 'Votable' do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:votable_name) { described_class.controller_name.singularize.underscore }
  let(:votable) { create(votable_name, user: user) }

  %w(vote_up vote_down).each do |attr|
    describe "POST ##{attr}" do
      let(:patch_vote) { patch attr.to_sym, id: votable, format: :json }

      context 'non-authenticated user' do
        it 'not change votes_sum' do
          expect { patch_vote }.not_to change(Vote, :count)
        end

        it 'response status error 401' do
          patch_vote
          expect(response.status).to eq(401)
        end
      end

      context 'authenticated user like owner voted post' do
        sign_in_user

        it 'not change votes_sum' do
          expect { patch_vote }.not_to change(Vote, :count)
        end

        it 'redirect to root path' do
          patch_vote
          expect(response.status).to eq(422)
        end
      end

      context 'another authenticated user' do
        sign_in_another_user

        it 'add vote to database' do
          expect { patch_vote }.to change(Vote, :count).by(1)
        end

        it 'change votes_sum' do
          vote_value = 1
          vote_value = -1 if attr == 'vote_down'
          expect {
            patch_vote
          }.to change { votable.votes_sum }.from(0).to(vote_value)
        end

        it 'render json success' do
          patch_vote
          expect(response).to be_success
        end
      end

      context 'another authenticated user voting multiple times' do
        sign_in_another_user
        before { patch attr.to_sym, id: votable, format: :json }

        it 'does not save second vote in database' do
          expect { patch_vote }.not_to change(Vote, :count)
        end

        it 'responds with error' do
          patch_vote
          expect(response.status).to eq(422)
        end
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    before { create(:vote, user: another_user, votable: votable) }

    context 'with user has vote' do
      sign_in_another_user

      it 'removes vote from database' do
        expect {
          patch :cancel_vote, id: votable, format: :json
        }.to change(Vote, :count).by(-1)
      end

      it 'changes votes_sum' do
        expect {
          patch :cancel_vote, id: votable, format: :json
        }.to change { votable.votes_sum }.from(1).to(0)
      end

      it 'responds with success' do
        patch :cancel_vote, id: votable, format: :json
        expect(response).to be_success
      end
    end

    context 'without user has vote' do
      sign_in_user
      it 'does not delete any vote from database' do
        expect {
          patch :cancel_vote, id: votable, format: :json
        }.not_to change(Vote, :count)
      end

      it 'responds with error' do
        patch :cancel_vote, id: votable, format: :json
        expect(response.status).to eq(422)
      end
    end
  end
end
