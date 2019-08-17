# Ridgepole::ReplaceDbTask

Replace rails db:migrate to use ridgepole

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ridgepole-replace_db_task'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ridgepole-replace_db_task

## Make initializer file

```config/initializers/ridgepole/replace_db_task.rb
Ridgepole::ReplaceDbTask.configure do |config|
  config.database_yml_path = ::Rails.root.join('config', 'database.yml')
  config.schema_file_path = ::Rails.root.join('db', 'schemas', 'Schemafile')
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/taka0125/ridgepole-replace_db_task.
