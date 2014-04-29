# Chinook

Shared deployment tasks that we use at [CaptainU](http://captainu.com) for our Capistrano deploys. We noticed we've been using a lot of these duplicated tasks per project, so this is an attempt to shoehorn those all into a shared gem that we can add per-project, and with minimal effort, simplify our codebase.

## Installation & Usage

Add this line to your application's `Gemfile`, preferrably in the `:development` group next to `capistrano`.

``` ruby
group :development do
  gem 'captainu-chinook'
  # or from git:
  # gem 'captainu-chinook', git: 'https://github.com/captainu/chinook.git'
end
```

And then execute:

``` bash
$ bundle
```

Each script will likely have its own set of configuration variables that you'll want to set, and many of them will be environment-specific. The format for these instructions is as follows:

``` ruby
# ./config/deploy.rb
# Towards the top of your deploy.rb file, require the library.

require 'chinook/capistrano/some_task'
# Optionally, require the whole kitchen sink with 'chinook/capistrano'

# ... Set the necessary variables required by the script.

set :ping_url, 'http://some-url-to-ping.example.com'

# ... Down a little further, near your other hooks, add the script's deployment task hook.

after 'deploy', 'chinook:some_task'
```

### Campfire notification

Notifies [Campfire](https://campfirenow.com) when a deploy starts and/or stops. Uses the value of `git config user.name` for identifying the deploying user.

* Tasks:
    - `chinook:campfire_start`
    - `chinook:campfire_fail`
    - `chinook:campfire_end`
* Hooks:
    - `before 'deploy', 'chinook:campfire_start'`
    - `after 'deploy:rollback', 'chinook:campfire_rollback'`
    - `after 'deploy', 'chinook:campfire_end'`
* Settings:
    - `:campfire_room_name`: the room where notifications will be posted.
    - `:campfire_token`: the API token of the user that this task will post as.
    - `:campfire_account_name`: the subdomain of your Campfire account (**this-part**.campfirenow.com).
    - `:project_name`: the name of your project as it will show up in the notifications. *Optional; if not supplied, the value of `:application` will be used.*

### Passenger restart

Restarts [Passenger](https://phusionpassenger.com) after deploy by touching the file at `tmp/restart.txt` on the receiving server.

* Task: `deploy:restart`
* Hook: None needed; automatically included
* Settings: None needed

### Ping

Pings the site after a [Passenger](phusionpassenger.com) deploy to ensure that it's immediately up and running following a restart task.

* Task: `chinook:ping`
* Hook: `after 'deploy:restart', 'chinook:ping'`
* Settings:
    - `:ping_url`: the URL you'd like to ping to wake up. *Environment specific.*

### Slack notification

Notifies [Slack](https://slack.com) when a deploy starts and/or stops. Uses the value of `git config user.name` for identifying the deploying user.

* Tasks:
    - `chinook:slack_start`
    - `chinook:slack_fail`
    - `chinook:slack_end`
* Hooks:
    - `before 'deploy', 'chinook:slack_start'`
    - `after 'deploy:rollback', 'chinook:slack_rollback'`
    - `after 'deploy', 'chinook:slack_end'`
* Settings:
    - `:slack_channel`: the room/channel where notifications will be posted.
    - `:slack_token`: the Slack webhook token for your team.
    - `:slack_team`: the subdomain of your Slack account (**this-part**.slack.com).
    - `:slack_username`: the username to be used when posting the message.
    - `:project_name`: the name of your project as it will show up in the notifications. *Optional; if not supplied, the value of `:application` will be used.*

### Symlink

Symlinks directories from various other directories into your project.

#### Symlink shared to public

Symlinks directories from `deploy_dir/shared` into your project's `deploy_dir/current/public` directory.

* Tasks: `chinook:symlink_shared_to_public`
* Hook: `after 'deploy:update_code', 'chinook:symlink_shared_to_public'`
* Settings:
    - `:public_directories`: a Ruby array of the directories you'd like to symlink from `shared`.

## Contributing

1. [Fork it](https://github.com/captainu/chinook/fork).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create a new Pull Request for it and we'll review it!

## Contributors

- [Ben Kreeger](https://github.com/kreeger)
- [Mike Admire](https://github.com/mikeadmire)
