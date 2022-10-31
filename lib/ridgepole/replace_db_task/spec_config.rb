require "active_support/configurable"

module Ridgepole
  module ReplaceDbTask
    class SpecConfig
      attr_reader :spec_name, :schema_file_path, :skip_drop_table, :ignore_tables, :multiple_migration_settings

      def initialize(spec_name:, schema_file_path:, skip_drop_table: true, ignore_tables: [], multiple_migration_settings: {development: %i[test]})
        @spec_name = spec_name
        @schema_file_path = schema_file_path
        @skip_drop_table = skip_drop_table
        @ignore_tables = ignore_tables
        @multiple_migration_settings = multiple_migration_settings

        freeze
      end
    end
  end
end
