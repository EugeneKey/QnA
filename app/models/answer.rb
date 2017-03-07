# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  question_id :integer
#  text        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  best_answer :boolean          default(FALSE), not null
#
class Answer < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user
  validates :text, :question_id, :user_id, presence: true

  after_create :notification

  default_scope { order('best_answer DESC, created_at') }

  def set_best
    transaction do
      question.answers.find_each { |a| a.update(best_answer: false) }
      update!(best_answer: true)
    end
  end

  def cancel_best
    update!(best_answer: false)
  end

  private

  def notification
    NewAnswerNotiferJob.perform_later(self)
  end
end
