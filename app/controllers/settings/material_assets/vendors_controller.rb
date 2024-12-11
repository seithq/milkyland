module Settings
  class MaterialAssets::VendorsController < ApplicationController
    include MaterialAssetScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_vendor, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @vendors = base_scope
    end

    def new
      @vendor = base_scope.new
    end

    def edit
    end

    def create
      @vendor = base_scope.new(vendor_params)

      if @vendor.save
        redirect_on_create edit_material_asset_path(@material_asset)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @vendor.update(vendor_params)
        redirect_on_update edit_material_asset_path(@material_asset)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @vendor.deactivate

      redirect_on_destroy edit_material_asset_path(@material_asset), text: t("actions.record_deactivated")
    end

    private
      def base_scope
        @material_asset.vendors.recent_first
      end

      def set_vendor
        @vendor = base_scope.find(params.expect(:id))
      end

      def vendor_params
        params.expect(vendor: %i[ supplier_id entry_price delivery_time_in_days active ])
      end
  end
end
