module Settings
  class Groups::SemiIngredientsController < ApplicationController
    include GroupScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_semi_ingredient, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @semi_ingredients = base_scope
    end

    def new
      @semi_ingredient = base_scope.new
    end

    def edit
    end

    def create
      @semi_ingredient = base_scope.new(semi_ingredient_params)

      if @semi_ingredient.save
        redirect_on_create edit_group_path(@group)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @semi_ingredient.update(semi_ingredient_params)
        redirect_on_update edit_group_path(@group)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @semi_ingredient.deactivate

      redirect_on_destroy edit_group_path(@group)
    end

    private
      def base_scope
        @group.semi_ingredients.recent_first
      end

      def search_methods
        []
      end

      def set_semi_ingredient
        @semi_ingredient = base_scope.find(params.expect(:id))
      end

      def semi_ingredient_params
        params.require(:semi_ingredient).permit(:semi_product_id, :ratio, :active)
      end
  end
end
