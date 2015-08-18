require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:another_user) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :create, :question }
    it { should be_able_to :create, :answer }
    it { should be_able_to :index, User }
    it { should be_able_to :me, User, id: user.id }

    %w(question answer).each do |model|
      context "#{model.classify}" do
        let(:resource) { create(model.to_sym, user: user) }
        let(:another_resource) { create(model.to_sym, user: another_user) }

        it { should be_able_to :update, resource, user: user }
        it { should_not be_able_to :update, another_resource, user: user }

        it { should be_able_to :destroy, resource, user: user }
        it { should_not be_able_to :destroy, another_resource, user: user }

        context 'Attachment destroy' do
          let(:attachment) { create(:attachment, attachable: resource) }
          let(:another_attachment) { create(:attachment,  attachable: another_resource) }

          it { should be_able_to :destroy, attachment,  user: user }
          it { should_not be_able_to :destroy, another_attachment,  user: user }
        end

        context 'Vote' do
          let(:voted_another_resource) { create(:vote, user: user, votable: another_resource) }
          let(:voted_resource) { create(:vote, user: another_user, votable: resource) }

          it { should be_able_to :vote_up, another_resource, user: user }
          it { should be_able_to :vote_down, another_resource, user: user }

          it { should_not be_able_to :vote_up, resource, user: user }
          it { should_not be_able_to :vote_down, resource, user: user }

          it do
            voted_another_resource
            should_not be_able_to :vote_up, another_resource, user: user
          end
          it do
            voted_another_resource
            should_not be_able_to :vote_down, another_resource, user: user
          end

          it do
            voted_another_resource
            should be_able_to :cancel_vote, another_resource, user: user
          end
          it { should_not be_able_to :cancel_vote, another_resource, user: user }
          it do
            voted_resource
            should_not be_able_to :cancel_vote, resource, user: user
          end
        end
      end
    end

    context 'Best Answer' do
      let(:question) { create(:question, user: user) }
      let(:another_question) { create(:question, user: another_user) }
      let(:not_best_answer) { create(:answer, user: user, question: another_question) }
      let(:not_best_another_answer) { create(:answer, user: another_user, question: question) }

      let(:best_answer) { create(:answer, user: user, question: another_question, best_answer: true) }
      let(:best_another_answer) { create(:answer, user: another_user, question: question, best_answer: true) }

      it { should be_able_to :set_best, not_best_another_answer, user: user }
      it { should_not be_able_to :set_best, not_best_answer, user: user }

      it { should be_able_to :cancel_best, best_another_answer, user: user }
      it { should_not be_able_to :cancel_best, best_answer, user: user }
    end
  end
end
