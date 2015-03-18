class UsagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where services: {church_id: user.church_id}
      end
    end
  end

  def update?
    false
  end
end