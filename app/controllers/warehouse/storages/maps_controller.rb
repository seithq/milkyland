module Warehouse
  class Storages::MapsController < ApplicationController
    include StorageScoped

    def show
      @zones = @storage.zones.ordered
    end
  end
end
