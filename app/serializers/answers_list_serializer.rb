class AnswersListSerializer < ActiveModel::Serializer
  attributes :id, :text, :updated_at, :created_at
end
