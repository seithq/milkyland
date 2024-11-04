module StackScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_stack
  end

  private
    def set_stack
      @stack = Stack.find(params[:stack_id])
    end
end
