module AccessGranted
  module Policy

    def initialize(user)
      @user = user
      configure(@user)
    end

    def configure(user)
    end

    def role(name, priority = nil, conditions = nil, &block)
      name = name.to_sym
      if roles.select {|r| r.name == name }.any?
        raise "Role '#{name}' already defined"
      end
      r = Role.new(name, priority, conditions, block)
      roles << r
      roles.sort_by! {|r| - r.priority }
      r
    end

    def roles
      @roles ||= []
    end

    def can?(action, subject)
      match_roles(@user).each do |role|
        permission = role.find_permission(action, subject)
        if permission
          return permission.granted
        end
      end
      false
    end

    def cannot?(*args)
      !can?(*args)
    end

    def match_roles(user)
      matching_roles = []
      roles.each do |role|
        matching_roles << role if role.applies_to?(user)
      end
      return matching_roles
    end

    def authorize!(action, subject)
      if cannot?(action, subject)
        raise AccessDenied
      end
      subject
    end
  end
end
