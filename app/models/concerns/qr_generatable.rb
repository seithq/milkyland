module QrGeneratable
  extend ActiveSupport::Concern

  included do
    after_create_commit :generate_qr
  end

  private
    def generate_qr
      QrGenerationJob.perform_later(self)
    end
end
