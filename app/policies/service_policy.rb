class ServicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where church_id: user.church_id
      end
    end
  end

  def create?
    #you can't do this if you're just a spectator
    user.church_leader? || user.church_admin || user.admin?
  end
end