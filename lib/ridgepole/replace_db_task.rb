module Ridgepole
  module ReplaceDbTask; end
end

require "ridgepole/replace_db_task/version"
require "ridgepole/replace_db_task/spec_config"
require "ridgepole/replace_db_task/config"
require "ridgepole/replace_db_task/executor"
require "ridgepole/replace_db_task/railtie" if defined?(::Rails::Railtie)

module Ridgepole
  module ReplaceDbTask
    class Error < StandardError; end

    class << self
      def configure(&block)
        yield @config ||= Config.new
      end

      def config
        @config
      end
    end
  end
end
