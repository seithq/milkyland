Rails.application.routes.draw do
  root to: "home#index"

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

  scope module: "sales" do
    scope "sales_channels/:sales_channel_id", as: "sales_channel", constraints: { sales_channel_id: /\d+/ } do
      resources :orders do
        scope module: "orders" do
          resources :positions, except: :show
        end
      end
    end

    resources :plans, except: %i[ new create ] do
      scope module: "plans" do
        resources :consolidations, except: %i[ show new create ]
        resources :groups, only: :index
      end
    end
  end

  namespace "production" do
    resources :plans, except: %i[ new create destroy ] do
      scope module: "plans" do
        get :summary, to: "summaries#index"
        resources :units, controller: "production_units", except: %i[ new create destroy ] do
          scope module: "production_units" do
            resources :batches, except: :destroy do
              scope module: "batches" do
                resources :journals, only: :show
                resources :steps, only: %i[ edit create update ]
                resource :packing, except: :destroy do
                  scope module: "packings" do
                    resources :packaged_products, only: %i[ index edit update ]
                  end
                end
                resource :distribution, except: :destroy do
                  scope module: "distributions" do
                    resources :distributed_products, only: %i[ index edit update ] do
                      scope module: "distributed_products" do
                        resource :generation, only: %i[ show new create ] do
                          scope module: "generations" do
                            resources :boxes, only: :index do
                              collection do
                                post :download, to: "boxes#download"
                              end
                            end
                            resources :pallets, only: %i[ index new create ] do
                              collection do
                                post :download, to: "pallets#download"
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  scope module: "procurements" do
    resources :supply_orders, except: :destroy
    resources :supply_operations do
      scope module: "supply_operations" do
        resources :leftovers, except: :show
      end
    end
    resources :supply_material_assets, only: %i[ index show ] do
      scope module: "supply_material_assets" do
        resources :storages, only: :index
      end
    end
  end

  scope module: "warehouse" do
    resources :storages, except: :destroy do
      scope module: "storages" do
        resources :subjects, only: :index
        resources :waybills, only: :index
        resources :zones do
          scope module: "zones" do
            resources :lines
          end
        end
      end
    end
    resources :waybills, only: %i[ index show ] do
      scope module: "waybills" do
        resources :leftovers, only: :index
      end
    end
    resources :boxes, only: %i[ index show ]
    resources :pallets, only: %i[ index show ]
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
        resources :box_packagings, except: :show
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

  get "up", to: "rails/health#show", as: :rails_health_check
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest
end
