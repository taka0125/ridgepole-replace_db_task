require "active_support/configurable"

module Ridgepole
  module ReplaceDbTask
    class Config
      include ActiveSupport::Configurable

      config_accessor :ridgepole, default: 'bundle exec ridgepole'
      config_accessor :database_yml_path, default: 'config/database.yml'
      config_accessor :spec_configs, default: [
        ::Ridgepole::ReplaceDbTask::SpecConfig.new(
          spec_name: nil,
          schema_file_path: 'db/schemas/Schemafile'
        )
      ]

      def spec_config(name)
        spec_configs.detect { |c| c.spec_name == name }
      end
    end
  end
end
