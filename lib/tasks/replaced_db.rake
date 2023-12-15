require "ridgepole/replace_db_task/executor"

namespace :db do
  desc 'db migrate use ridgepole'
  task migrate: :environment do
    rails_env = ENV.fetch('RAILS_ENV', 'development')

    ::Ridgepole::ReplaceDbTask.config.spec_configs.each do |spec_config|
      apply(rails_env, spec_config)

      envs = spec_config.multiple_migration_settings.dig(rails_env.to_sym) || []
      envs.each do |env|
        apply(env, spec_config)
      end
    end
  end

  desc 'apply dry run'
  task apply_dry_run: :environment do
    rails_env = ENV.fetch('RAILS_ENV', 'development')

    ::Ridgepole::ReplaceDbTask.config.spec_configs.each do |spec_config|
      dry_run(rails_env, spec_config)
    end
  end

  private

  def apply(env, spec_config)
    execute_ridgepole(env, spec_config.spec_name, spec_config.other_options, false) { |line| puts line }
  end

  def dry_run(env, spec_config)
    execute_ridgepole(env, spec_config.spec_name, spec_config.other_options, true) { |line| puts line }
  end

  def execute_ridgepole(env, spec_name, other_options, dry_run, &block)
    ::Ridgepole::ReplaceDbTask::Executor.call(
      env: env,
      spec_name: spec_name,
      other_options: other_options,
      block: block,
      dry_run: dry_run
    )
  end
end
