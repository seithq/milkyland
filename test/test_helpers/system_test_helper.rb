module SystemTestHelper
  include ActionView::Helpers::JavaScriptHelper

  def sign_in(email_address, password = "secret123456")
    visit new_session_url

    fill_in "email_address", with: email_address
    fill_in "password", with: password

    click_on "sign_in"
    assert_selector ".breadcrumb-link", text: I18n.t("pages.home")
  end
end
