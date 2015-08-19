require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_should_behave_like 'Votable'

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answers) { create_list(:answer, 2, question: question) }
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns the requested answers to @answers' do
      expect(assigns(:answers)).to match_array answers
    end

    it 'assigns the new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'authenticated user' do
      sign_in_user
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'non-authenticated user' do
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to_not be_a_new(Question)
      end

      it 'renders new user' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'non-authenticated user' do
      it 'does not save question' do
        expect { post :create, question: attributes_for(:question) }.to_not change(Question, :count)
      end

      it 'redirects to user sing_in' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not send json new question through private pub' do
        expect(PrivatePub).not_to receive(:publish_to).with('/questions/index', anything)
        post :create, question: attributes_for(:question)
      end
    end

    context 'authenticated user with valid attributes' do
      sign_in_user
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'put user_id from current_user to new question' do
        post :create, question: attributes_for(:question)
        expect(question.user_id).to eq user.id
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'send json new question through private pub' do
        expect(PrivatePub).to receive(:publish_to).with('/questions/index', anything)
        post :create, question: attributes_for(:question)
      end
    end

    context 'authenticated user with invalid attributes' do
      sign_in_user
      it 'does not save question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end

      it 'does not send json new question through private pub' do
        expect(PrivatePub).not_to receive(:publish_to).with('/questions/index', anything)
        post :create, question: attributes_for(:invalid_question)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'valid attributes' do
      before { patch :update, id: question, question: { title: 'new title 10', text: 'new body' } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        question.reload
        expect(question.title).to eq 'new title 10'
        expect(question.text).to eq 'new body'
      end

      it 'redirects to the updated question' do
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: { title: 'new wrong title', text: nil } }
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to_not eq 'new wrong title'
        expect(question.text).to_not eq nil
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'another authenticated user' do
      sign_in_another_user
      before { patch :update, id: question, question: { title: 'new title 10', text: 'new body' } }

      it 'does not changes question attributes' do
        question.reload
        expect(question.title).to_not eq 'new title 10'
        expect(question.text).to_not eq 'new body'
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      sign_in_user
      it 'deletes question' do
        question
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end

      it 'redirect to question' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context 'another authenticated user' do
      sign_in_another_user
      it 'do not deletes question' do
        question
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it 'redirect to root path' do
        delete :destroy, id: question
        expect(response).to redirect_to root_path
      end
    end

    context 'non-authenticated user' do
      it 'not deletes question' do
        question
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it 'redirect to sign_in' do
        delete :destroy, id: question
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
