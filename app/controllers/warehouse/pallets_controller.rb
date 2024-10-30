class Warehouse::PalletsController < ApplicationController
  before_action :set_pallet, only: :show

  def index
    @pagy, @pallets = pagy get_scope(params)
  end

  def show
  end

  private
    def base_scope
      Pallet.recent_first
    end

    def search_methods
      %i[ code ]
    end

    def set_pallet
      @pallet = base_scope.find(params.expect(:id))
    end
end
