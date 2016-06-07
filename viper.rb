require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'faker'
require 'couchrest'

require 'byebug'

HEADLESS = true

if HEADLESS
  Capybara.current_driver = :poltergeist
  Capybara.javascript_driver = :poltergeist

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, {js_errors: false})
  end
else
  Capybara.current_driver = :selenium
end

Capybara.run_server = false
Capybara.app_host = 'https://www.reddit.com'

module Leviathan
  class Viper
    include Capybara::DSL

    def initialize(db)
      @db = db
    end

    def spawn
      username = "#{Faker::Internet.user_name.tr('.', '_')}_#{SecureRandom.hex[0..4]}"
      password = Faker::Internet.password(10)

      puts "username: #{username}"
      puts "password: #{password}"

      visit '/'
      click_on 'Log in or sign up'
      fill_in 'user_reg', :with => username
      fill_in 'passwd_reg', :with => password
      fill_in 'passwd2_reg', :with => password
      click_on 'sign up'

      if page.has_text? "you are doing that too much"
        raise RuntimeError, 'Rate Limited'
      end
      if page.has_css? '.c-form-control-feedback-error'
        elem = page.find '.c-form-control-feedback-error'
        raise RuntimeError, elem['data-original-title']
      end
      doc = @db.save_doc(
        '_id'       => username,
        'username'  => username,
        'ptpwd'     => password,
        'createdAt' => Time.now.utc.iso8601)
      doc
    end
  end
end

server = CouchRest.new ENV['COUCH']
viper = Leviathan::Viper.new server.database!('zergling')
result = viper.spawn
puts result
