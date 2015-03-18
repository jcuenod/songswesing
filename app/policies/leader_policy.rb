class LeaderPolicy < ApplicationPolicy
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
    user.church_admin? || user.admin?
  end
end