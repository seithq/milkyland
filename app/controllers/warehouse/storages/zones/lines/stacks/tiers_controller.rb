module Warehouse::Storages::Zones::Lines
  class Stacks::TiersController < ApplicationController
    include StorageScoped, ZoneScoped, LineScoped, StackScoped

    before_action :set_tier, only: %i[ show edit update destroy ]

    def index
      @pagy, @tiers = pagy get_scope(params)
    end

    def show
    end

    def new
      @tier = Tier.new
    end

    def edit
    end

    def create
      if Tier.repeat tier_params[:repeat], @stack
        redirect_on_create edit_storage_zone_line_stack_url(@storage, @zone, @line, @stack)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @tier.update(tier_params)
        redirect_on_update edit_storage_zone_line_stack_url(@storage, @zone, @line, @stack)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @tier.deactivate

      redirect_on_destroy storage_zone_line_stack_tiers_url(@storage, @zone, @line, @stack), text: t("actions.record_deactivated")
    end

    private
      def base_scope
        @stack.tiers.ordered
      end

      def set_tier
        @tier = base_scope.find(params.expect(:id))
      end

      def tier_params
        params.expect(tier: %i[ active repeat ])
      end
  end
end
