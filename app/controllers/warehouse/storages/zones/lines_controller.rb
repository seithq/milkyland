module Warehouse::Storages
  class Zones::LinesController < ApplicationController
    include StorageScoped, ZoneScoped

    before_action :set_line, only: %i[ show edit update destroy ]

    def index
      @pagy, @lines = pagy get_scope(params)
    end

    def show
    end

    def new
      @line = Line.new
    end

    def edit
    end

    def create
      if Line.repeat line_params[:repeat], @zone
        redirect_on_create edit_storage_zone_url(@storage, @zone)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @line.update(line_params)
        redirect_on_update edit_storage_zone_url(@storage, @zone)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @line.deactivate

      redirect_on_destroy storage_zone_lines_url(@storage, @zone), text: t("actions.record_deactivated")
    end

    private
      def base_scope
        @zone.lines.ordered
      end

      def set_line
        @line = base_scope.find(params.expect(:id))
      end

      def line_params
        params.expect(line: %i[ repeat active ])
      end
  end
end
