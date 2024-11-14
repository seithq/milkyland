module Mobile
  class Waybills::LocationsController < MobileController
    rescue_from ActionController::ParameterMissing, with: :handle_missing_params

    def new
      @location = Location.new
    end

    def create
      @positionable, @storables = find_positionable, find_storables

      if locate_all @storables, to: @positionable
        redirect_on_create feed_url
      else
        flash[:alert] = t("actions.code_not_found")
        render :new, status: :unprocessable_entity
      end
    end

    private
      def location_params
        params.expect(location: [ :positionable_code, storable_codes: [] ])
      end

      def find_positionable
        Scan.find_by location_params[:positionable_code], allowed_prefixes: %w[ Z T P ]
      end

      def find_storables
        location_params[:storable_codes].map do |code|
          Scan.find_by code, allowed_prefixes: %w[ B P ]
        end
      end

      def locate_all(storables, to:)
        storables.each { |storable| storable.locate_to to }
      end

      def handle_missing_params
        @location = Location.new
        flash.now[:alert] = t("actions.failed_location_save")
        render :new, status: :unprocessable_entity
      end
  end
end
