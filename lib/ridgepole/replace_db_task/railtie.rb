class Ridgepole::ReplaceDbTask::Railtie < ::Rails::Railtie
  rake_tasks do
    load 'tasks/replaced_db.rake'
  end
end
