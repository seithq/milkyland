class Settings::MeasurementsController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update ]
  before_action :set_measurement, only: %i[ show edit update ]

  def index
    @pagy, @measurements = pagy get_scope(params)
  end

  def show
  end

  def new
    @measurement = Measurement.new
  end

  def edit
  end

  def create
    @measurement = Measurement.new(measurement_params)

    if @measurement.save
      redirect_on_create measurements_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @measurement.update(measurement_params)
      redirect_on_update measurements_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      Measurement.recent_first
    end

    def search_methods
      []
    end
    def set_measurement
      @measurement = Measurement.find(params[:id])
    end

    def measurement_params
      params.require(:measurement).permit(:name, :unit)
    end
end
