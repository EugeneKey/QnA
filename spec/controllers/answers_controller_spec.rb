require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_should_behave_like 'Votable'

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    context 'non-authenticated user' do
      it 'does not save answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it 'response 401' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response.status).to eq(401)
      end
    end

    context 'authenticated user with valid attributes' do
      sign_in_user
      it 'saves the new answer for question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 'put user_id from current_user to new answer' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(answer.user_id).to eq user.id
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'authenticated user with invalid attributes' do
      sign_in_user
      it 'does not save answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'valid attributes' do
      before { patch :update, question_id: question, id: answer, answer: { text: 'new body' }, format: :js  }

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        answer.reload
        expect(answer.text).to eq 'new body'
      end

      it 'render update template' do
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, question_id: question, id: answer, answer: { text: nil }, format: :js  }
      it 'does not change question attributes' do
        answer.reload
        expect(answer.text).to_not eq nil
      end

      it 'render update template' do
        expect(response).to render_template :update
      end
    end

    context 'another authenticated user' do
      sign_in_another_user
      before { patch :update, question_id: question, id: answer, answer: { text: 'new body' }, format: :js  }

      it 'does not changes answer attributes' do
        answer.reload
        expect(answer.text).to_not eq 'new body'
      end

      it 'respond status unprocessable entity' do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH #best_answer' do
    let(:answer_2) { create(:answer, question: question, user: another_user) }
    sign_in_user
    context 'author question select best answer' do
      before { patch :set_best, question_id: question, id: answer, format: :js  }

      it 'this answer the best' do
        expect(answer.reload.best_answer).to be_truthy
      end

      it 'another answer not best' do
        expect(answer_2.reload.best_answer).to be_falsey
      end

      it 'this answer became the first' do
        expect(question.answers.first).to eq answer
      end

      it 'render set_best' do
        expect(response).to render_template :set_best
      end
    end

    context 'author selects the two best answers' do
      before do
        patch :set_best, question_id: question, id: answer, format: :js
        patch :set_best, question_id: question, id: answer_2, format: :js
      end

      it 'second selected answer the best' do
        expect(answer_2.reload.best_answer).to be_truthy
      end

      it 'first selected answer is not best' do
        expect(answer.reload.best_answer).to be_falsey
      end

      it 'second selected answer became the first' do
        expect(question.answers.first).to eq answer_2
      end

      it 'best answer only one' do
        expect(question.answers.where(best_answer: true).count).to eq 1
      end

      it 'render set_best' do
        expect(response).to render_template :set_best
      end
    end

    context 'not author the question try to select the best answer' do
      sign_in_another_user
      before { patch :set_best, question_id: question, id: answer_2, format: :js }

      it 'selected answer is not best' do
        expect(answer_2.reload.best_answer).to be_falsey
      end

      it 'not have best answer' do
        expect(question.answers.where(best_answer: true).count).to eq 0
      end

      it 'respond status unprocessable entity' do
        expect(response.status).to eq(422)
      end
    end

    context 'author question cancel best answer' do
      let(:answer_best) { create(:answer, question: question, user: another_user, best_answer: true) }
      before { patch :cancel_best, question_id: question, id: answer_best, format: :js }

      it 'not have best answer' do
        expect(answer_best.reload.best_answer).to be_falsey
      end

      it 'render cancel_best' do
        expect(response).to render_template :cancel_best
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      sign_in_user
      it 'deletes answer' do
        answer
        expect { delete :destroy, id: answer, question_id: question, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'another authenticated user' do
      sign_in_another_user
      it 'do not deletes answer' do
        answer
        expect { delete :destroy, id: answer, question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'respond status unprocessable entity' do
        delete :destroy, id: answer, question_id: question, format: :js
        expect(response.status).to eq(422)
      end
    end

    context 'non-authenticated user' do
      it 'not deletes answer' do
        answer
        expect { delete :destroy, id: answer, question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'redirect to sign_in' do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
