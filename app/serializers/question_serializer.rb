class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :created_at, :updated_at
  has_many :comments, :attachments
end
