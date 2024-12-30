module Mobile
  class Tasks::ReturnsController < MobileController
    before_action :set_return, only: %i[ show edit update ]

    def index
      @pagy, @returns = pagy_countless get_scope(params)
    end

    def show
    end

    def edit
    end

    def update
      if @return.update(return_params)
        ProcessReturnJob.perform_later @return.id
        redirect_on_update tasks_returns_url, text: t("actions.record_approved")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
      def base_scope
        authorized_scope(Return.all).recent_first
      end

      def set_return
        @return = Return.find(params.expect(:id))
      end

      def return_params
        params.expect(return: [ :accepting_user_id, :status ])
      end
  end
end
