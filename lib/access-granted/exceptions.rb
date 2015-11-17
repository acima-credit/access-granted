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

    attr_reader :path, :message

    def initialize(path = '/', message = "You don't have permissions to access this page.")
      @path, @message = path, message
    end

  end
end
