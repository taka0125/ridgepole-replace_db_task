require "ridgepole/replace_db_task/executor"

namespace :db do
  desc 'db migrate use ridgepole'
  task migrate: :environment do
    ::Ridgepole::ReplaceDbTask.config.spec_configs.each do |spec_config|
      ENV['RAILS_ENV'] ||= 'development'
      apply(ENV['RAILS_ENV'], spec_config.spec_name, '--apply') { |line| puts line }

      envs = spec_config.multiple_migration_settings.dig(ENV['RAILS_ENV'].to_sym) || []
      envs.each do |env|
        apply(env, spec_config.spec_name, '--apply') { |line| puts line }
      end
    end
  end

  desc 'apply dry run'
  task apply_dry_run: :environment do
    ::Ridgepole::ReplaceDbTask.config.spec_configs.each do |spec_config|
      ENV['RAILS_ENV'] ||= 'development'

      apply(ENV['RAILS_ENV'], spec_config.spec_name, '--apply --dry-run') do |line|
        puts line
      end
    end
  end

  private

  def apply(rails_env, spec_name, options, &block)
    ::Ridgepole::ReplaceDbTask::Executor.call(rails_env, spec_name, options, block)
  end
end
