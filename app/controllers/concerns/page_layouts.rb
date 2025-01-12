module PageLayouts
  extend ActiveSupport::Concern

  included do
    layout :layout_by_resource
  end

  private
    def layout_by_resource
      whitelist = %w[ sessions transfers first_runs qr_code registrations ]
      if whitelist.include?(controller_name) && !controller_path.start_with?("reports")
        "blank"
      else
        "application"
      end
    end
end
