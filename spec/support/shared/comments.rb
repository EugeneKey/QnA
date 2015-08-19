RSpec.shared_examples 'Commentable' do
  context 'non-authenticated user' do
    it 'does not save comment' do
      expect { do_request }.to_not change(Comment, :count)
    end

    it 'response status 401' do
      do_request
      expect(response.status).to eq(401)
    end
  end

  context 'authenticated user with valid attributes' do
    sign_in_user
    it 'saves the new comment' do
      expect { do_request }.to change(commentable.comments, :count).by(1)
    end

    it 'association user with comment' do
      expect { do_request }.to change(user.comments, :count).by(1)
    end

    it 'respond with success' do
      do_request
      expect(response).to be_success
    end

    it 'send json array through private pub' do
      expect(PrivatePub).to receive(:publish_to).with("/questions/#{question.id}/comments", anything)
      do_request
    end
  end

  context 'authenticated user with invalid attributes' do
    sign_in_user
    it 'does not save comment' do
      expect { do_request(comment: attributes_for(:invalid_comment)) }.to_not change(Comment, :count)
    end

    it 'responds with error unprocessable entity' do
      do_request(comment: attributes_for(:invalid_comment))
      expect(response.status).to eq(422)
    end

    it 'does not send json array through private pub' do
      expect(PrivatePub).not_to receive(:publish_to).with("/questions/#{question.id}/comments", anything)
      do_request(comment: attributes_for(:invalid_comment))
    end
  end
end
