module UsersHelper
  def user_status_tag(user)
    tag.span class: user.active? ? "text-green-700" : "text-green-700" do
      user.active? ? t("user_statuses.active") : t("user_statuses.inactive")
    end
  end
end
