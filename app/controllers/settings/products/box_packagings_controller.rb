module Settings
  class Products::BoxPackagingsController < ApplicationController
    include ProductScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_box_packaging, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @box_packagings = base_scope.recent_first
    end

    def new
      @box_packaging = base_scope.new
    end

    def edit
    end

    def create
      @box_packaging = base_scope.new(box_packaging_params)

      if @box_packaging.save
        redirect_on_create edit_product_url(@product)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @box_packaging.update(box_packaging_params)
        redirect_on_update edit_product_url(@product)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @box_packaging.deactivate

      redirect_on_destroy edit_product_url(@product)
    end

    private
      def base_scope
        @product.box_packagings
      end

      def search_methods
        []
      end

      def set_box_packaging
        @box_packaging = base_scope.find(params.expect(:id))
      end

      def box_packaging_params
        params.require(:box_packaging).permit(:material_asset_id, :count, :active)
      end
  end
end
