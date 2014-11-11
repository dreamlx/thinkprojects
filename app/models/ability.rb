class Ability
  include CanCan::Ability
  def initialize(user)
    user ||= User.new
    if user.roles == "providence_breaker"
      can :manage, :all
    elsif user.roles == "guest"
      can :read, User, :id == user.id
    elsif user.roles == "employee"
      can [:read, :update,], User, id: user.id
      can [:read, :create, :update], Personalcharge, user_id: user.id
      can [:update, :destroy], Personalcharge, user_id: user.id, state: ["disapproved","pending"]
      can [:read], Project, user_id: user.id
    elsif user.roles == "staff"
      can [:read, :update], User, id: user.id
      can [:read, :create, :update], Personalcharge, user_id: user.id
      can [:update, :destroy], Personalcharge, user_id: user.id, state: ["disapproved","pending"]
      can [:read], Project, user_id: user.id
    elsif user.roles == "senior"
    elsif user.roles == "manager"
    elsif user.roles == "hr_admin"
      can [:read, :update], User
      can [:read, :create, :update], Personalcharge, user_id: user.id
      can [:update, :destroy], Personalcharge, user_id: user.id, state: ["disapproved","pending"]
      can [:read, :create, :update], Project
      can [:read, :create, :update], Client
    elsif user.roles == "partner"
      can [:read, :update], User, id: user.id
      can [:approval, :disapproval,:addcomment, :read], Personalcharge, state: "pending"
      can [:update, :destroy], Personalcharge, user_id: user.id, state: ["disapproved","pending"]
      can [:read, :create], Project
      can [:update, :destroy], Project, manager_id: user.id, state: ["disapproved","pending"]
      can [:approval, :disapproval,:addcomment], Project, state: "pending"
      can [:close], Project, manager_id: user.id, state: "approved"
    end
  end
end
