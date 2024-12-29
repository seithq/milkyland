module Logistics
  class Returns::ReturnedProductsController < ApplicationController
    include ReturnScoped, ReadModes

    before_action :set_returned_product, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @returned_products = base_scope
    end

    def new
      @returned_product = base_scope.new
    end

    def edit
    end

    def create
      @returned_product = base_scope.new(returned_product_params)

      if @returned_product.save
        redirect_on_create edit_return_url(@return)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @returned_product.update(returned_product_params)
        redirect_on_update edit_return_url(@return)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @returned_product.destroy!

      redirect_on_destroy return_returned_products_url(@return)
    end

    private
      def base_scope
        @return.returned_products.recent_first
      end

      def set_returned_product
        @returned_product = base_scope.find(params.expect(:id))
      end

      def returned_product_params
        params.expect(returned_product: %i[ product_id count ])
      end
  end
end
