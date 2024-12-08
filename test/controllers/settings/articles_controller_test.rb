require "test_helper"

class Settings::ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:operational_income_client)
    sign_in :daniyar
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get new" do
    get new_article_url
    assert_response :success
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: { article: { activity_type_id: @article.activity_type_id, financial_category_id: @article.financial_category_id, kind: @article.kind, name: "New Article" } }
    end

    assert_redirected_to articles_url
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should get edit" do
    get edit_article_url(@article)
    assert_response :success
  end

  test "should update article" do
    patch article_url(@article), params: { article: { activity_type_id: @article.activity_type_id, financial_category_id: @article.financial_category_id, kind: @article.kind, name: @article.name } }
    assert_redirected_to articles_url
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end

    assert_redirected_to articles_url
  end
end
