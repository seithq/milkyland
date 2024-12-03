module Settings
  class Products::SinglePackagingsController < ApplicationController
    include ProductScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_single_packaging, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @single_packagings = base_scope.recent_first
    end

    def new
      @single_packaging = base_scope.new
    end

    def edit
    end

    def create
      @single_packaging = base_scope.new(single_packaging_params)

      if @single_packaging.save
        redirect_on_create edit_product_url(@product)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @single_packaging.update(single_packaging_params)
        redirect_on_update edit_product_url(@product)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @single_packaging.deactivate

      redirect_on_destroy edit_product_url(@product)
    end

    private
      def base_scope
        @product.single_packagings
      end

      def set_single_packaging
        @single_packaging = base_scope.find(params.expect(:id))
      end

      def single_packaging_params
        params.expect(single_packaging: %i[ material_asset_id active ])
      end
  end
end
