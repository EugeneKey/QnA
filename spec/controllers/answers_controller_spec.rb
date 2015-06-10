require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, question_id: question, id: answer }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'non-authenticated user' do
      it 'does not save answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it 'redirects to user sign_in' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authenticated user with valid attributes' do
      sign_in_user
      it 'saves the new answer for question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'put user_id from current_user to new answer' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(answer.user_id).to eq user.id
      end

      it 'redirects to answer' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'authenticated user with invalid attributes' do
      sign_in_user
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
    sign_in_user
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
        expect(answer.text).to_not eq nil
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'another authenticated user' do
      sign_in_another_user
      before { patch :update, question_id: question, id: answer, answer: { text: 'new body' } }

      it 'does not changes answer attributes' do
        answer.reload
        expect(answer.text).to_not eq 'new body'
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      sign_in_user
      it 'deletes answer' do
        answer
        expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question' do
        delete :destroy, id: answer
        expect(response).to redirect_to question
      end
    end

    context 'another authenticated user' do
      sign_in_another_user
      it 'do not deletes answer' do
        answer
        expect { delete :destroy, id: answer }.to_not change(Answer, :count)
      end

      it 'redirect to question' do
        delete :destroy, id: answer
        expect(response).to redirect_to question
      end
    end

    context 'non-authenticated user' do
      it 'not deletes answer' do
        answer
        expect { delete :destroy, id: answer }.to_not change(Answer, :count)
      end

      it 'redirect to sign_in' do
        delete :destroy, id: answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
