class UsagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where church_id: current_user.church_id
      end
    end
  end

  def update?
    false
  end
end