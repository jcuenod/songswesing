class SongPolicy < ApplicationPolicy
  def create?
    user.church_admin? || user.admin?
  end

  def update?
    user.admin?
  end
end