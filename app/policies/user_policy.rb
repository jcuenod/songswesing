class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where church_id: user.church_id
      end
    end
  end

  def can_grant_admin?
    user.admin?
  end
  def update?
    user.admin? || (user.church_admin? && (record.church_id == user.church_id))
  end
  def destroy?
    user.admin?
  end
end
