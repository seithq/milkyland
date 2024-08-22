Rails.application.routes.draw do
  root "home#index"

  resource :first_run, only: %i[ show create ]

  resource :session, only: %i[ new create destroy ] do
    scope module: "sessions" do
      resources :transfers, only: %i[ show update ]
    end
  end

  get "join/:join_code", to: "registrations#new", as: :join
  post "join/:join_code", to: "registrations#create"

  resource :account do
    scope module: "accounts" do
      resource :join_code, only: :create
    end
  end

  resources :qr_code, only: :show
  resources :users do
    scope module: "users" do
      resource :profile
    end
  end

  scope module: "settings" do
    resources :regions, except: :destroy
    resources :sales_channels, except: :destroy
    resources :suppliers, except: :destroy
    resources :categories, except: :destroy
    resources :measurements, except: :destroy
    resources :material_assets, except: :destroy
    resources :groups, except: :destroy do
      scope module: "groups" do
        resources :ingredients, except: :show
        resources :standards, except: :show
        resources :journals, except: :show
        resources :operations, except: :show
        resources :fields, except: :show
      end
    end
    resources :products, except: :destroy do
      scope module: "products" do
        resources :prices, except: :show
      end
    end
    resources :clients, except: :destroy do
      scope module: "clients" do
        resources :sales_points, except: :show
      end
    end
    resources :packing_machines, except: :destroy do
      scope module: "packing_machines" do
        resources :containers, except: :show
      end
    end
    resources :promotions do
      scope module: "promotions" do
        resources :participants, except: :show
        resources :discounted_products, except: :show
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
