require "open3"

class Ridgepole::ReplaceDbTask::Executor
  def self.call(rails_env, options, block)
    new(rails_env, options, block).call
  end

  def call
    raise 'config.database_yml_path is required.' if Ridgepole::ReplaceDbTask.config.database_yml_path.blank?
    raise 'config.schema_file_path is required.' if Ridgepole::ReplaceDbTask.config.schema_file_path.blank?

    command = <<~EOD
      #{Ridgepole::ReplaceDbTask.config.ridgepole} \
        -c #{Ridgepole::ReplaceDbTask.config.database_yml_path} \
        -f #{Ridgepole::ReplaceDbTask.config.schema_file_path} \
        #{ignore_tables_option} \
        #{skip_drop_table_option} \
        #{@options} \
        -E #{@rails_env}
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

  def initialize(rails_env, options, block)
    @rails_env = rails_env
    @options = options
    @block = block
  end

  private

  def ignore_tables_option
    ignore_tables = Ridgepole::ReplaceDbTask.config.ignore_tables
    ignore_tables.present? ? '--ignore-tables ' + ignore_tables.map { |t| t.is_a?(Regexp) ? t.source : "^#{t}$" }.join(',') : ''
  end

  def skip_drop_table_option
    skip_drop_table = Ridgepole::ReplaceDbTask.config.skip_drop_table
    skip_drop_table ? '--skip-drop-table' : ''
  end
end
