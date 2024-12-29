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
    resources :plans, except: :destroy do
      scope module: "plans" do
        get :summary, to: "summaries#index"
        resources :units, controller: "production_units", except: %i[ new create destroy ] do
          scope module: "production_units" do
            resources :batches, except: :destroy do
              get "info", to: "batches#info", on: :member
              get "summary", to: "batches#summary", on: :member

              scope module: "batches" do
                resources :journals, only: :show
                resources :steps, only: %i[ edit create update ]
                resource :packing, except: :destroy do
                  scope module: "packings" do
                    resources :packaged_products, only: %i[ index edit update ] do
                      scope module: "packaged_products" do
                        resources :machineries, except: :show do
                          collection do
                            get "search", to: "machineries#search"
                          end
                        end
                      end
                    end
                  end
                end
                resource :cooking, except: :destroy do
                  scope module: "cookings" do
                    resources :cooked_semi_products, only: %i[ index edit update ]
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
    resources :supply_orders, except: :destroy do
      collection do
        get "search", to: "supply_orders#search"
      end
    end
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
    scope module: "storages" do
      get "warehousers/search", to: "warehousers#search", as: :warehousers_search
    end

    resources :storages, except: :destroy do
      scope module: "storages" do
        resources :subjects, only: :index
        resources :waybills, only: :index
        resources :zones do
          scope module: "zones" do
            resources :lines do
              scope module: "lines" do
                resources :stacks do
                  scope module: "stacks" do
                    resources :tiers
                  end
                end
              end
            end
          end
        end
        resource :map, only: :show
        resources :warehousers, except: :show
      end
    end
    resources :waybills, only: %i[ index show edit update ] do
      scope module: "waybills" do
        resources :leftovers, only: :index
        resources :qr_scans, only: %i[ index edit update ]
      end
    end
    resources :boxes, only: %i[ index show ] do
      collection do
        get "location/:positionable_id/:positionable_type", to: "boxes#location", as: :location
      end
    end
    resources :pallets, only: %i[ index show ] do
      collection do
        get "location/:positionable_id/:positionable_type", to: "pallets#location", as: :location
      end
    end
  end

  scope module: "settings" do
    resources :regions, except: :destroy
    resources :sales_channels, except: :destroy
    resources :suppliers, except: :destroy
    resources :categories, except: :destroy
    resources :measurements, except: :destroy
    resources :material_assets, except: :destroy do
      scope module: "material_assets" do
        resources :vendors, except: :show
      end
    end
    resources :groups, except: :destroy do
      scope module: "groups" do
        resources :ingredients, except: :show
        resources :semi_ingredients, except: :show
        resources :standards, except: :show
        resources :journals, except: :show
        resources :operations, except: :show
        resources :fields, except: :show
      end
    end
    resources :products, except: :destroy do
      scope module: "products" do
        resources :prices, except: :show
        resources :custom_prices, except: :show
        resources :box_packagings, except: :show
        resources :single_packagings, except: :show
      end
    end
    resources :semi_products, except: :destroy
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
    resources :activity_types
    resources :financial_categories
    resources :companies
    resources :bank_accounts
    resources :articles
  end

  scope module: "logistics" do
    resources :shipments do
      scope module: "shipments" do
        resources :route_sheets do
          scope module: "route_sheets" do
            resources :tracking_products
            resources :tracking_orders
          end
        end
      end
    end
    resources :returns do
      scope module: "returns" do
        resources :returned_products, except: :show
      end
    end
  end

  scope module: "mobile" do
    resource :feed, only: :show
    resources :scans, only: %i[ index new ]
    namespace :waybills do
      resources :arrivals, except: :index
      resources :write_offs, except: :index
      resources :transfers, except: :index
      resources :departures, except: :index
      resources :locations, only: %i[ new create ]

      scope ":waybill_id/mobile" do
        resources :qr_scans, except: %i[ new show ]
        resource :recommendation, only: :show
      end
    end
    namespace :journals do
      resources :outgoings, only: :index
      resources :incomings, only: :index
    end
    namespace :load do
      resources :assemblies do
        scope module: "assemblies" do
          resources :qr_scans, except: %i[ new show ]
          resource :recommendation, only: :show
        end
      end
    end
  end

  scope module: "finance" do
    resources :transactions do
      collection do
        get "search", to: "transactions#search"
      end
    end
    resources :account_transfers, only: %i[ new create ]
    resource :cash_flow, only: %i[ show create ]
  end

  get "/configurations/android", to: "configurations#android", as: :android_configuration
  get "up", to: "rails/health#show", as: :rails_health_check
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest
end
