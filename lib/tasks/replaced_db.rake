require "ridgepole/replace_db_task/executor"

namespace :db do
  def apply(rails_env, options, &block)
    ::Ridgepole::ReplaceDbTask::Executor.call(rails_env, options, block)
  end

  desc 'db migrate use ridgepole'
  task migrate: :environment do
    ENV['RAILS_ENV'] ||= 'development'
    apply(ENV['RAILS_ENV'], '--apply') { |line| puts line }

    if ENV['RAILS_ENV'] == 'development' && ::Ridgepole::ReplaceDbTask.config.migrate_with_test_when_development
      apply('test', '--apply') { |line| puts line }
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
