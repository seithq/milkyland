class Logistics::ReturnsController < ApplicationController
  before_action :set_status
  before_action :set_return, only: %i[ show edit update destroy ]

  def index
    @pagy, @returns = pagy get_scope(params)
    authorize!
  end

  def show
  end

  def new
    @return = Return.new
    authorize! @return
  end

  def edit
  end

  def create
    @return = Return.new(return_params)
    @return.user = Current.user
    authorize! @return

    if @return.save
      redirect_on_create returns_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @return.update(return_params)
      redirect_on_update returns_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @return.destroy!

    redirect_on_destroy returns_url
  end

  private
    def base_scope
      Return.filter_by_status(@status).recent_first
    end

    def search_methods
      %i[ user order storage status ]
    end

    def set_return
      @return = Return.find(params.expect(:id))
      authorize! @return
    end

    def return_params
      params.expect(return: %i[ user_id order_id storage_id comment ])
    end

    def set_status
      @status = params[:status].presence || "draft"
    end
end
