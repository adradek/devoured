module Sorcery
  module TestHelpers
    module Rails
      module Request
        def logout_request
          send(:delete, logout_path)
        end
      end
    end
  end
end
