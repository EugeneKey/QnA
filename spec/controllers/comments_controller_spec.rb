require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    describe 'question comments' do
      context 'non-authenticated user' do
        it 'does not save comment' do
          expect do
            post :create,
                 question_id: question,
                 commentable: 'questions',
                 comment: attributes_for(:comment),
                 format: :js
          end.to_not change(Comment, :count)
        end

        it 'response status 401' do
          post :create,
               question_id: question,
               commentable: 'questions',
               comment: attributes_for(:comment),
               format: :js
          expect(response.status).to eq(401)
        end
      end

      context 'authenticated user with valid attributes' do
        sign_in_user
        it 'saves the new comment' do
          expect do
            post :create,
                 question_id: question,
                 commentable: 'questions',
                 comment: attributes_for(:comment),
                 format: :js
          end.to change(question.comments, :count).by(1)
        end

        it 'association user with comment' do
          expect do
            post :create,
                 question_id: question,
                 commentable: 'questions',
                 comment: attributes_for(:comment),
                 format: :js
          end.to change(user.comments, :count).by(1)
        end

        it 'respond with success' do
          post :create,
               question_id: question,
               commentable: 'questions',
               comment: attributes_for(:comment),
               format: :js
          expect(response).to be_success
        end

        it 'send json array through private pub' do
          expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/comments", anything)
          post :create,
               question_id: question,
               commentable: 'questions',
               comment: attributes_for(:comment),
               format: :js
        end
      end

      context 'authenticated user with invalid attributes' do
        sign_in_user
        it 'does not save comment' do
          expect do
            post :create,
                 question_id: question,
                 commentable: 'questions',
                 comment: attributes_for(:invalid_comment),
                 format: :js
          end.to_not change(Comment, :count)
        end

        it 'responds with error unprocessable entity' do
          post :create,
               question_id: question,
               commentable: 'questions',
               comment: attributes_for(:invalid_comment),
               format: :js
          expect(response.status).to eq(422)
        end

        it 'does not send json array through private pub' do
          expect(PrivatePub).not_to receive(:publish_to).with("/questions/#{question.id}/comments", anything)
          post :create,
               question_id: question,
               commentable: 'questions',
               comment: attributes_for(:invalid_comment),
               format: :js
        end
      end
    end

    describe 'answer comments' do
      context 'non-authenticated user' do
        it 'does not save comment' do
          expect do
            post :create,
                 question_id: question,
                 commentable: 'answers',
                 comment: attributes_for(:comment),
                 format: :js
          end.to_not change(Comment, :count)
        end

        it 'response status 401' do
          post :create,
               question_id: question,
               commentable: 'answers',
               comment: attributes_for(:comment),
               format: :js
          expect(response.status).to eq(401)
        end
      end

      context 'authenticated user with valid attributes' do
        sign_in_user
        it 'saves the new comment' do
          expect do
            post :create,
                 question_id: question,
                 commentable: 'answers',
                 comment: attributes_for(:comment),
                 format: :js
          end.to change(question.comments, :count).by(1)
        end

        it 'association user with comment' do
          expect do
            post :create,
                 question_id: question,
                 commentable: 'answers',
                 comment: attributes_for(:comment),
                 format: :js
          end.to change(user.comments, :count).by(1)
        end

        it 'respond with success' do
          post :create,
               question_id: question,
               commentable: 'answers',
               comment: attributes_for(:comment),
               format: :js
          expect(response).to be_success
        end

        it 'send json array through private pub' do
          expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/comments", anything)
          post :create,
               question_id: question,
               commentable: 'answers',
               comment: attributes_for(:comment),
               format: :js
        end
      end

      context 'authenticated user with invalid attributes' do
        sign_in_user
        it 'does not save comment' do
          expect do
            post :create,
                 question_id: question,
                 commentable: 'answers',
                 comment: attributes_for(:invalid_comment),
                 format: :js
          end.to_not change(Comment, :count)
        end

        it 'responds with error unprocessable entity' do
          post :create,
               question_id: question,
               commentable: 'answers',
               comment: attributes_for(:invalid_comment),
               format: :js
          expect(response.status).to eq(422)
        end

        it 'does not send json array through private pub' do
          expect(PrivatePub).not_to receive(:publish_to).with("/questions/#{question.id}/comments", anything)
          post :create,
               question_id: question,
               commentable: 'answers',
               comment: attributes_for(:invalid_comment),
               format: :js
        end
      end
    end
  end
end
