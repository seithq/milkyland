module Settings
  class Promotions::ParticipantsController < ApplicationController
    include PromotionScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_participant, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @participants = base_scope.recent_first
    end

    def new
      @participant = base_scope.new
    end

    def edit
    end

    def create
      @participant = base_scope.new(participant_params)

      if @participant.save
        redirect_on_create edit_promotion_url(@promotion)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @participant.update(participant_params)
        redirect_on_update edit_promotion_url(@promotion)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @participant.deactivate

      redirect_on_destroy edit_promotion_url(@promotion)
    end

    private
      def base_scope
        @promotion.participants
      end

      def search_methods
        []
      end

      def set_participant
        @participant = base_scope.find(params[:id])
      end

      def participant_params
        params.require(:participant).permit(:client_id, :active)
      end
  end
end
