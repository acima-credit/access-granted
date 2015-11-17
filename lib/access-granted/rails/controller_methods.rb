module AccessGranted
  module Rails
    module ControllerMethods
      def current_policy
        @current_policy ||= ::AccessPolicy.new(current_user)
      end

      def self.included(base)
        base.helper_method :can?, :cannot?, :current_policy
      end

      def can?(*args)
        current_policy.can?(*args)
      end

      def cannot?(*args)
        current_policy.cannot?(*args)
      end

      def authorize!(*args)
        current_policy.authorize!(*args)
      end

      def authorize_with_path!(*args)
        current_policy.authorize_with_path!(*args)
      end
    end
  end
end
