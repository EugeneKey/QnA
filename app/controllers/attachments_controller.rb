class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment
  before_action :access_attach

  respond_to :js

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def access_attach
    redirect_to root_path, notice: 'Access denied' if  @attachment.attachable.user_id != current_user.id
  end
end
