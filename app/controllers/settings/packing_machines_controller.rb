class Settings::PackingMachinesController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update ]
  before_action :set_packing_machine, only: %i[ show edit update ]

  def index
    @pagy, @packing_machines = pagy get_scope(params)
  end

  def show
  end

  def new
    @packing_machine = PackingMachine.new
  end

  def edit
  end

  def create
    @packing_machine = PackingMachine.new(packing_machine_params)

    if @packing_machine.save
      redirect_on_create edit_packing_machine_url(@packing_machine)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @packing_machine.update(packing_machine_params)
      redirect_on_update packing_machines_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      PackingMachine.recent_first
    end

    def search_methods
      []
    end

    def set_packing_machine
      @packing_machine = PackingMachine.find(params[:id])
    end

    def packing_machine_params
      params.require(:packing_machine).permit(:name)
    end
end
