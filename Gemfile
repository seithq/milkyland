source "https://rubygems.org"

ruby file: ".ruby-version"

gem "rails", github: "rails/rails", branch: "main"

# Drivers
gem "pg", "~> 1.1"
gem "redis", ">= 4.0.1"

# Deployment
gem "puma", ">= 5.0"
gem "kamal", require: false

# Jobs
gem "solid_queue", "~> 0.3.4"

# Front-end
gem "propshaft"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "requestjs-rails", "~> 0.0.11"
gem "inline_svg", "~> 1.9"
gem "pagy", "~> 9.0"
gem "rails-i18n", "~> 7.0"

# Other
gem "jbuilder"
gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "image_processing", "~> 1.2"
gem "aws-sdk-s3", "~> 1.156"
gem "rqrcode", "~> 2.2"
gem "useragent", github: "basecamp/useragent"
gem "zipline", "~> 2.0"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
