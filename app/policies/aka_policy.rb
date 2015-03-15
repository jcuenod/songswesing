class AkaPolicy < ApplicationPolicy
  def update?
    user.admin?
  end
end