require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "should validate system integrity" do
    category = FinancialCategory.new kind: :income, name: "Transfer Income"
    assert category.save

    article = Article.new kind: :income,
                          activity_type: activity_types(:operational),
                          financial_category: category,
                          name: "Transfer Income Article",
                          system: true
    assert article.save

    copy = Article.new kind: :income,
                          activity_type: activity_types(:operational),
                          financial_category: category,
                          name: "Copy Transfer Income Article",
                          system: true
    assert_not copy.save
    assert_equal :taken, copy.errors.where(:system).first.type
  end
end
