module Zipable
  extend ActiveSupport::Concern

  included do
    def download
      ArchiveGenerationJob.perform_later init_download.id, zip_name, zip_class, zip_scope.pluck(:id)
      redirect_to post_download_url
    end
  end

  private
    def init_download
      raise NotImplementedError.new "Implement in subclass"
    end

    def zip_class
      raise NotImplementedError.new "Implement in subclass"
    end

    def zip_scope
      raise NotImplementedError.new "Implement in subclass"
    end

    def zip_name
      raise NotImplementedError.new "Implement in subclass"
    end

    def post_download_url
      raise NotImplementedError.new "Implement in subclass"
    end
end
