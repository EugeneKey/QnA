class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities

    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer], user: user

    can [:set_best], Answer do |answer|
      answer.question.user == user && !answer.best_answer
    end

    can [:cancel_best], Answer do |answer|
      answer.question.user == user && answer.best_answer
    end

    can [:vote_up, :vote_down], [Question, Answer] do |votable|
      votable.user != user && !votable.vote(user)
    end

    can :cancel_vote, [Question, Answer] do |votable|
      votable.user != user && votable.vote(user)
    end

    can :destroy, Attachment, attachable: { user: user }

    can :create, Subscription do |subscription|
      !user.subscribed?(subscription.question)
    end

    can :destroy, Subscription do |subscription|
      user.subscribed?(subscription.question) && user != subscription.question.user
    end

    # API Ability
    can :create, [:question, :answer]
    can :index, User
    can :me, User, id: user.id
  end
end
