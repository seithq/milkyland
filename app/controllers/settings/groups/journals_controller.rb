module Settings
  class Groups::JournalsController < ApplicationController
    include GroupScoped, ReadModes

    before_action :ensure_can_administer, only: %i[ create update destroy ]
    before_action :set_journal, only: %i[ edit update destroy ]
    before_action :set_read_mode, only: :index

    def index
      @journals = base_scope.recent_first
    end

    def new
      @journal = base_scope.new
    end

    def edit
    end

    def create
      @journal = base_scope.new(journal_params)

      if @journal.save
        redirect_on_create edit_group_path(@group)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @journal.update(journal_params)
        redirect_on_update edit_group_path(@group)
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @journal.deactivate

      redirect_on_destroy edit_group_path(@group)
    end

    private
      def base_scope
        @group.journals
      end

      def search_methods
        []
      end

      def set_journal
        @journal = base_scope.find(params[:id])
      end

      def journal_params
        params.require(:journal).permit(:name, :chain_order, :active, :unordable)
      end
  end
end
