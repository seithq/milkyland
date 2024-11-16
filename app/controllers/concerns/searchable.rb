module Searchable
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def base_scope
    end

    def search_methods
    end

    def get_scope(params)
      scope = base_scope
      filtering_params(params).each do |key, value|
        scope = scope.public_send("filter_by_#{key}", value) if value.present?
      end
      scope
    end

    def filtering_params(params)
      return {} unless params[:search].present?

      params[:search].slice(*search_methods)
    end
  end

  private

  def record_not_found(exception)
    flash[:alert] = exception.to_s
    redirect_back(fallback_location: root_path)
  end
end
