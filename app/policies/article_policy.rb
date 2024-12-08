class ArticlePolicy < ApplicationPolicy
  def destroy?
    owned? && has_empty_associations?
  end

  private
    def owned?
      user.admin?
    end

    def has_empty_associations?
      record.transactions.count.zero?
    end
end
