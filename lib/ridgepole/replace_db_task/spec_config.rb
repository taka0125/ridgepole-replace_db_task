module Ridgepole
  module ReplaceDbTask
    class SpecConfig
      attr_reader :spec_name, :schema_file_path, :multiple_migration_settings, :other_options

      def initialize(spec_name:, schema_file_path:, multiple_migration_settings: { development: %i[test] }, other_options: [])
        @spec_name = spec_name
        @schema_file_path = schema_file_path
        @multiple_migration_settings = multiple_migration_settings
        @other_options = other_options

        freeze
      end
    end
  end
end
