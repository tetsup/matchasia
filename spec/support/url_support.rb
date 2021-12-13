module UrlSupport
  def wait_for_change_url(timeout_sec = 3)
    current_path = page.current_path
    yield
    Timeout.timeout(timeout_sec) do
      until page.current_path == current_path
        sleep(0.1)
      end
    end
  end
end

RSpec.configure do |config|
  config.include UrlSupport
end
