# Defines a task that will reboot passenger upon deploy.
require 'capistrano'

module Chinook::Capistrano
  module Passenger
    def self.load_into(configuration)
      configuration.load do
        namespace :deploy do
          desc 'Restarts Passenger by touching tmp/restart.txt.'
          task :restart, roles: :app, except: { no_release: true } do
            run "touch #{current_path}/tmp/restart.txt"
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Chinook::Capistrano::Passenger.load_into(Capistrano::Configuration.instance)
end
