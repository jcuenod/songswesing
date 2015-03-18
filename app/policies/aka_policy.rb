class AkaPolicy < ApplicationPolicy
  def create?
    #must be same or less restrictive than song.create? policy
    user.church_admin? || user.admin?
  end
  def update?
    user.admin?
  end
end