class Warehouse::StoragesController < ApplicationController
  before_action :set_storage, only: %i[ show edit update ]

  def index
    @pagy, @storages = pagy get_scope(params)
  end

  def show
  end

  def new
    @storage = base_scope.new
  end

  def edit
  end

  def create
    @storage = base_scope.new(storage_params)

    if @storage.save
      redirect_on_create storages_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @storage.update(storage_params)
      redirect_on_update storages_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def base_scope
      Storage.recent_first
    end

    def search_methods
      %i[ name kind ]
    end

    def set_storage
      @storage = base_scope.find(params.expect(:id))
    end

    def storage_params
      params.expect(storage: [ :name, :kind ])
    end
end
