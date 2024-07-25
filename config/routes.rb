Rails.application.routes.draw do
  root "home#index"

  resource :first_run, only: %i[ show create ]
  resource :session, only: %i[ new create destroy ]

  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
