module AccessGranted
  module Rails
    module ControllerMethods
      def current_policy
        @current_policy ||= ::AccessPolicy.new(current_user)
      end

      def self.included(base)
        base.helper_method :can?, :cannot?, :current_policy if base.respond_to? :helper_method
      end

      def can?(*args)
        current_policy.can?(*undecorated_args(args))
      end

      def cannot?(*args)
        current_policy.cannot?(*undecorated_args(args))
      end

      def authorize!(*args)
        current_policy.authorize!(*undecorated_args(args))
      end

      def authorize_with_path!(*args)
        current_policy.authorize_with_path!(*undecorated_args(args))
      end

      private

      def undecorated_args(args)
        args.map { |arg| arg.is_a?(Array) ? undecorated_args(arg) : undecorated_arg(arg) }
      end

      def undecorated_arg(arg)
        return arg unless arg.class.name =~ /Decorator$/ && arg.respond_to?(:object)

        arg.object
      end

    end
  end
end
