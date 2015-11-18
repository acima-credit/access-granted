module AccessGranted

  class Error < StandardError
  end

  class DuplicatePermission < Error
  end

  class DuplicateRole < Error
  end

  class AccessDenied < Error
  end

  class AccessDeniedWithPath < AccessDenied

    attr_reader :path, :message, :action, :subject

    def initialize(path = nil, message = nil, action = nil, subject = nil)
      @path    = path || '/'
      @message = message || "You don't have permissions to access this page."
      @action  = action
      @subject = subject
    end

  end
end
