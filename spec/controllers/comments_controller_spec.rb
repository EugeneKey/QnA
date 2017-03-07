# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    describe 'question comments' do
      let!(:commentable) { question }

      it_behaves_like 'Commentable'

      def do_request(options = {})
        post :create, { question_id: commentable,
                        commentable: 'questions',
                        comment: attributes_for(:comment),
                        format: :json }.merge(options)
      end
    end

    describe 'answer comments' do
      let!(:commentable) { create(:answer, question: question) }

      it_behaves_like 'Commentable'

      def do_request(options = {})
        post :create, { answer_id: commentable,
                        commentable: 'answers',
                        comment: attributes_for(:comment),
                        format: :json }.merge(options)
      end
    end
  end
end
