class Settings::SuppliersController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update ]
  before_action :set_supplier, only: %i[ show edit update ]

  def index
    @pagy, @suppliers = pagy get_scope(params)
  end

  def show
  end

  def new
    @supplier = Supplier.new
  end

  def edit
  end

  def create
    @supplier = Supplier.new(supplier_params)

    if @supplier.save
      redirect_on_create suppliers_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @supplier.update(supplier_params)
      redirect_on_update suppliers_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      Supplier.recent_first
    end

    def search_methods
      []
    end

    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    def supplier_params
      params.require(:supplier).permit(:name, :bin, :contact_person, :job_title, :phone_number, :email_address, :entity_code, :bank_name, :bank_account, :bank_code, :manager_id, uploads: [])
    end
end
