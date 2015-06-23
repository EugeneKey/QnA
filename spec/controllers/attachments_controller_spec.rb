require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachable: question) }

  describe 'DELETE #destroy' do
      context 'authenticated user' do
        sign_in_user
        it 'deletes attachment' do
          expect { delete :destroy, id: attachment, format: :js }
              .to change(question.attachments, :count).by(-1)
        end

        it 'render destroy template' do
          delete :destroy, id: attachment, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'another authenticated user' do
        sign_in_another_user
        it 'do not deletes attachment' do
          expect { delete :destroy, id: attachment, format: :js }
              .to_not change(question.attachments, :count)
        end

        it 'render destroy template' do
          delete :destroy, id: attachment, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'non-authenticated user' do
        it 'not deletes attachment' do
          expect { delete :destroy, id: attachment, format: :js }
              .to_not change(question.attachments, :count)
        end

        it 'redirect to sign_in' do
          delete :destroy, id: attachment
          expect(response).to redirect_to new_user_session_path
        end
      end
  end
end