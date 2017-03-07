# frozen_string_literal: true
class AttachmentSerializer < ActiveModel::Serializer
  belongs_to :question_id

  attributes :url

  def url
    object.file.url
  end
end
