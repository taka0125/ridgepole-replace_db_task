require "open3"

class Ridgepole::ReplaceDbTask::Executor
  def self.call(rails_env, spec_name, options, block)
    new(rails_env, spec_name, options, block).call
  end

  def call
    raise 'config.database_yml_path is required.' if Ridgepole::ReplaceDbTask.config.database_yml_path.blank?
    raise 'config.schema_file_path is required.' if spec_config.schema_file_path.blank?

    command = <<~EOD
      #{Ridgepole::ReplaceDbTask.config.ridgepole} \
        -c #{Ridgepole::ReplaceDbTask.config.database_yml_path} \
        -f #{spec_config.schema_file_path} \
        #{ignore_tables_option} \
        #{drop_table_option} \
        #{spec_name_option} \
        #{options} \
        -E #{rails_env}
EOD
    puts command

    out = []
    is_success = Open3.popen2e(command) do |stdin, stdout_and_stderr, wait_thr|
      stdin.close

      stdout_and_stderr.each_line do |line|
        out << line
        @block.call(line)
      end

      wait_thr.value.success?
    end

    out.join("\n")

    exit(1) unless is_success
  end

  def initialize(rails_env, spec_name, options, block)
    @rails_env = rails_env
    @spec_name = spec_name
    @options = options
    @block = block
  end

  private

  attr_reader :rails_env, :spec_name, :options, :block

  def spec_config
    @spec_config ||= Ridgepole::ReplaceDbTask.config.spec_config(spec_name)
  end

  def ignore_tables_option
    ignore_tables = spec_config.ignore_tables
    ignore_tables.present? ? '--ignore-tables ' + ignore_tables.map { |t| t.is_a?(Regexp) ? t.source : "^#{t}$" }.join(',') : ''
  end

  def drop_table_option
    skip_drop_table = spec_config.skip_drop_table
    skip_drop_table ? '' : '--drop-table'
  end

  def spec_name_option
    return '' if spec_name.blank?

    "--spec-name #{spec_name}"
  end
end
