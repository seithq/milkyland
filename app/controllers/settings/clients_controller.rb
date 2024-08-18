class Settings::ClientsController < ApplicationController
  before_action :ensure_can_administer, only: %i[ create update ]
  before_action :set_client, only: %i[ show edit update ]

  def index
    @pagy, @clients = pagy get_scope(params)
  end

  def show
  end

  def new
    @client = Client.new
  end

  def edit
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_on_create clients_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      redirect_on_update clients_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      Client.recent_first
    end

    def search_methods
      [ :name_or_bin ]
    end

    def set_client
      @client = Client.find(params[:id])
    end

    def client_params
      params.require(:client).permit(:name, :bin, :contact_person, :job_title, :phone_number, :email_address, :entity_code, :bank_name, :bank_account, :bank_code, :manager_id, uploads: [])
    end
end
