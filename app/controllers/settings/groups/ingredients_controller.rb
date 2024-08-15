module Settings
  class Groups::IngredientsController < ApplicationController
    include GroupScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_ingredient, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @ingredients = base_scope.recent_first
    end

    def new
      @ingredient = base_scope.new
    end

    def edit
    end

    def create
      @ingredient = base_scope.new(ingredient_params)

      if @ingredient.save
        redirect_on_create edit_group_path(@group)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @ingredient.update(ingredient_params)
        redirect_on_update edit_group_path(@group)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @ingredient.deactivate

      redirect_on_destroy edit_group_path(@group)
    end

    private
      def base_scope
        @group.ingredients.active
      end

      def search_methods
        []
      end

      def set_ingredient
        @ingredient = base_scope.find(params[:id])
      end

      def ingredient_params
        params.require(:ingredient).permit(:material_asset_id, :ratio)
      end
  end
end
