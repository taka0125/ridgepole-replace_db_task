require "active_support/configurable"

module Ridgepole
  module ReplaceDbTask
    class Config
      include ActiveSupport::Configurable

      config_accessor :ridgepole
      config_accessor :database_yml_path
      config_accessor :schema_file_path
      config_accessor :skip_drop_table
      config_accessor :ignore_tables
    end
  end
end
