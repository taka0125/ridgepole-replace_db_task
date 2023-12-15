require "open3"

class Ridgepole::ReplaceDbTask::Executor
  private_class_method :new

  class << self
    def call(env:, spec_name:, block:, other_options: [], dry_run: true)
      new(env, spec_name, block, other_options, dry_run).call
    end
  end

  def call
    raise 'config.database_yml_path is required.' if Ridgepole::ReplaceDbTask.config.database_yml_path.blank?
    raise 'config.schema_file_path is required.' if spec_config.schema_file_path.blank?

    options = other_options.dup
    options << "--config #{Ridgepole::ReplaceDbTask.config.database_yml_path}"
    options << "--file #{spec_config.schema_file_path}"
    options << "--env #{env}"
    options << "--apply"
    options << "--dry-run" if dry_run
    options << "--spec-name #{spec_name}" if spec_name.present?

    command = "#{Ridgepole::ReplaceDbTask.config.ridgepole} #{options.join(' ')}"
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

  private

  attr_reader :env, :spec_name, :other_options, :block, :dry_run, :spec_config

  def initialize(env, spec_name, block, other_options, dry_run)
    @env = env
    @spec_name = spec_name
    @block = block
    @other_options = other_options
    @dry_run = dry_run

    @spec_config = Ridgepole::ReplaceDbTask.config.spec_config(spec_name)

    freeze
  end
end
