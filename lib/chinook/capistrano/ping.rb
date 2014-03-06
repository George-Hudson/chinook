# Defines a task that will ping the website after a Passenger restart.
require 'capistrano'

module Chinook::Capistrano
  module Ping
    def self.load_into(configuration)
      configuration.load do
        namespace :chinook do
          desc 'Sends a basic curl request to the website to wake it up.'
          task :ping, except: { no_release: true } do
            unless exists?(:ping_url)
              logger.info 'Cannot ping website without :ping_url defined. Skipping task.'
              next
            end

            rails_env = fetch(:rails_env, 'production')
            destination = fetch(:ping_url)
            ping_command = "curl -LI #{destination}"

            logger.info "Pinging website to wake it up at #{destination}"
            if configuration.dry_run
              logger.info "DRY RUN: Ping not sent."
            else
              result = ""
              run(ping_command, once: true) { |ch, stream, data| result << data }
            end
            logger.info "Ping sent; site should now be awake and responsive."
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Chinook::Capistrano::Ping.load_into(Capistrano::Configuration.instance)
end
