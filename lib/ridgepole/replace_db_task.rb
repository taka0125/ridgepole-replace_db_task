module Ridgepole
  module ReplaceDbTask; end
end

require "ridgepole/replace_db_task/version"
require "ridgepole/replace_db_task/config"
require "ridgepole/replace_db_task/executor"
require "ridgepole/replace_db_task/railtie" if defined?(::Rails::Railtie)

module Ridgepole
  module ReplaceDbTask
    class Error < StandardError; end

    def self.configure(&block)
      yield @config ||= Config.new
    end

    def self.config
      @config
    end

    configure do |config|
      config.ridgepole = 'bundle exec ridgepole'
      config.skip_drop_table = true
      config.ignore_tables = []
      config.multiple_migration_settings = {development: %i[test]}
    end
  end
end
