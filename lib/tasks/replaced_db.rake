require "ridgepole/replace_db_task/executor"

namespace :db do
  def apply(rails_env, options, &block)
    ::Ridgepole::ReplaceDbTask::Executor.call(rails_env, options, block)
  end

  desc 'db migrate use ridgepole'
  task migrate: :environment do
    ENV['RAILS_ENV'] ||= 'development'
    apply(ENV['RAILS_ENV'], '--apply') { |line| puts line }

    envs = ::Ridgepole::ReplaceDbTask.config.multiple_migration_settings.dig(ENV['RAILS_ENV'].to_sym) || []
    envs.each do |env|
      apply(env, '--apply') { |line| puts line }
    end
  end

  desc 'apply dry run'
  task apply_dry_run: :environment do
    ENV['RAILS_ENV'] ||= 'development'

    apply(ENV['RAILS_ENV'], '--apply --dry-run') do |line|
      puts line
    end
  end
end
