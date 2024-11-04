module Warehouse::Storages::Zones
  class Lines::StacksController < ApplicationController
    include StorageScoped, ZoneScoped, LineScoped

    before_action :set_stack, only: %i[ show edit update destroy ]

    def index
      @pagy, @stacks = pagy get_scope(params)
    end

    def show
    end

    def new
      @stack = Stack.new
    end

    def edit
    end

    def create
      if Stack.repeat stack_params[:repeat], @line
        redirect_on_create edit_storage_zone_line_url(@storage, @zone, @line)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @stack.update(stack_params)
        redirect_on_update edit_storage_zone_line_url(@storage, @zone, @line)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @stack.deactivate

      redirect_on_destroy storage_zone_line_stacks_url(@storage, @zone, @line), text: t("actions.record_deactivated")
    end

    private
      def base_scope
        @line.stacks.ordered
      end

      def set_stack
        @stack = base_scope.find(params.expect(:id))
      end

      def stack_params
        params.expect(stack: %i[ active repeat ])
      end
  end
end
