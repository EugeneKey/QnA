class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  def destroy
    @attachment.destroy if @attachment.attachable.user_id == current_user.id
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
