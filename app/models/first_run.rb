class FirstRun
  ACCOUNT_NAME = "MilkyLand"

  def self.create!(user_params)
    Account.create!(name: ACCOUNT_NAME)
    User.create!(user_params.merge(role: :admin))
  end
end
