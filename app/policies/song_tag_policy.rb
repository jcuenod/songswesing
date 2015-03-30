class SongTagPolicy < ApplicationPolicy
  # class Scope < Scope
  #   def resolve
  #     if user.admin?
  #       scope.all
  #     else
  #       scope.where church_id: user.church_id
  #     end
  #   end
  # end

  def create_and_destroy?
    user.admin? || user.church_admin? || user.church_leader?
  end
end