require "active_support"
require "active_support/core_ext/class/attribute"

module Ridgepole
  module ReplaceDbTask
    class Config
      class_attribute :ridgepole, default: 'bundle exec ridgepole'
      class_attribute :database_yml_path, default: 'config/database.yml'
      class_attribute :spec_configs, default: [
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
