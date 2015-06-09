require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #edit' do
    before { get :edit, question_id: question, id: answer }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer for question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirects to answer' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      before { patch :update, question_id: question, id: answer, answer: { text: 'new body' } }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        answer.reload
        expect(answer.text).to eq 'new body'
      end

      it 'redirects to the updated question' do
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'invalid attributes' do
      before { patch :update, question_id: question, id: answer, answer: { text: nil } }
      it 'does not change question attributes' do
        answer.reload
        expect(answer.text).to eq answer.text
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end
end
