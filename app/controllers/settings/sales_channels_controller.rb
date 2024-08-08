class Settings::SalesChannelsController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update ]
  before_action :set_sales_channel, only: %i[ show edit update ]

  def index
    @pagy, @sales_channels = pagy get_scope(params)
  end

  def show
  end

  def new
    @sales_channel = SalesChannel.new
  end

  def edit
  end

  def create
    @sales_channel = SalesChannel.new(sales_channel_params)

    if @sales_channel.save
      redirect_on_create sales_channels_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @sales_channel.update(sales_channel_params)
      redirect_on_update sales_channels_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      SalesChannel.ordered
    end

    def search_methods
      []
    end

    def set_sales_channel
      @sales_channel = SalesChannel.find(params[:id])
    end

    def sales_channel_params
      params.require(:sales_channel).permit(:name)
    end
end
