namespace :db do
  desc "fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'

    User.populate(10) do |user|
      # user.nickname    = Faker::Name.name
      user.email       = Faker::Internet.email
      user.encrypted_password = Faker::Crypto.sha256
      user.sign_in_count = 1..300
      Question.populate 1..10 do |question|
        question.title = Populator.words(1..5).titleize
        question.text = Populator.paragraphs(1..5)
        question.user_id = user.id
        question.created_at = 1.years.ago..Time.now
        Comment.populate 0..10 do |comment|
          comment.text = Populator.sentences(1..3)
          comment.user_id = rand(1..user.id)
          comment.commentable_type = 'Question'
          comment.commentable_id = question.id
        end
        Answer.populate 5..20 do |answer|
          answer.question_id = question.id
          answer.user_id = rand(1..user.id)
          answer.text = Populator.paragraphs(1..5)
          answer.best_answer = false
          answer.created_at = 1.years.ago..Time.now
          Comment.populate 0..10 do |comment|
            comment.text = Populator.sentences(1..3)
            comment.user_id = rand(1..user.id)
            comment.commentable_type = 'Answer'
            comment.commentable_id = answer.id
          end
        end
        Answer.populate 1 do |answer|
          answer.question_id = question.id
          answer.user_id = rand(1..user.id)
          answer.text = Populator.sentences(5..10)
          answer.best_answer = (rand(0..1) == 0)
          answer.created_at = 1.years.ago..Time.now
          Comment.populate 0..10 do |comment|
            comment.text = Populator.sentences(1..3)
            comment.user_id = rand(1..user.id)
            comment.commentable_type = 'Answer'
            comment.commentable_id = answer.id
          end
        end
      end
    end
  end
end