require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token not valid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'return list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title text updated_at created_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id text updated_at created_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions/1', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token not valid' do
        get '/api/v1/questions/1', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title text updated_at created_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      it 'does not contain answers' do
        expect(response.body).to_not have_json_path('questions/0/answers')
      end

      context 'comments' do
        %w(id text created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('question/attachments/0/url')
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions', format: :json,
                                  question: attributes_for(:question)
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post '/api/v1/questions', format: :json,
                                  question: attributes_for(:question), access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'returns 201 status code' do
          post '/api/v1/questions', format: :json,
                                    question: attributes_for(:question),
                                    access_token: access_token.token
          expect(response).to have_http_status :created
        end

        it 'saves the new question in the database' do
          expect do
            post '/api/v1/questions', format: :json,
                                      question: attributes_for(:question),
                                      access_token: access_token.token
          end.to change(Question, :count).by(1)
        end

        it 'assigns created question to the user' do
          expect do
            post '/api/v1/questions', format: :json,
                                      question: attributes_for(:question),
                                      access_token: access_token.token
          end.to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 401 status code' do
          post '/api/v1/questions', format: :json,
                                    question: attributes_for(:invalid_question),
                                    access_token: access_token.token
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'do not save the new question in the database' do
          expect do
            post '/api/v1/questions', format: :json,
                                      question: attributes_for(:invalid_question),
                                      access_token: access_token.token
          end.to_not change(Question, :count)
        end

        it 'do not assign created question to the user' do
          expect do
            post '/api/v1/questions', format: :json,
                                      question: attributes_for(:invalid_question),
                                      access_token: access_token.token
          end.to_not change(user.questions, :count)
        end
      end
    end
  end
end
