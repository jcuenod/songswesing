class LeaderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where church_id: current_user.church_id
      end
    end
  end

  def create?
    user.church_admin? || user.admin?
  end
end