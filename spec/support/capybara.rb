RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome, options: {
      browser: :remote,
      url: 'http://selenium_chrome:4444/wd/hub'
    }
    Capybara.server_host = 'app'
  end
end
