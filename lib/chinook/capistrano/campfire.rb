# Defines a task that will let a Campfire room know about a deploy.
require 'capistrano'
require 'tinder'

module Chinook::Capistrano
  module Campfire
    def self.load_into(configuration)
      configuration.load do
        namespace :chinook do
          desc 'Lets a Campfire room know about a deploy that is about to start.'
          task :campfire_start, except: { no_release: true } do
            unless exists?(:campfire_room_name) && exists?(:campfire_token) && exists?(:campfire_account_name)
              logger.info 'Cannot notify Campfire without :campfire_room_name, :campfire_token, and :campfire_account_name. Skipping task.'
              next
            end

            project_name = fetch(:project_name, application)
            git_username = `git config user.name`.chomp

            message = "#{git_username} started a deploy of #{project_name} to #{stage} at #{Time.now.strftime('%r %Z')}."
            room_name = fetch(:campfire_room_name)
            token = fetch(:campfire_token)
            account_name = fetch(:campfire_account_name)

            campfire = Tinder::Campfire.new(account_name, token: token)
            room = campfire.find_room_by_name(room_name)
            room.speak(message)
          end

          desc 'Lets a Campfire room know about a deploy has finished.'
          task :campfire_end, except: { no_release: true } do
            unless exists?(:campfire_room_name) && exists?(:campfire_token) && exists?(:campfire_account_name)
              logger.info 'Cannot notify Campfire without :campfire_room_name, :campfire_token, and :campfire_account_name. Skipping task.'
              next
            end

            project_name = fetch(:project_name, application)
            git_username = `git config user.name`.chomp

            message = "#{git_username}'s deploy of #{project_name} to #{stage} finished at #{Time.now.strftime('%r %Z')}."
            room_name = fetch(:campfire_room_name)
            token = fetch(:campfire_token)
            account_name = fetch(:campfire_account_name)

            campfire = Tinder::Campfire.new(account_name, token: token)
            room = campfire.find_room_by_name(room_name)
            room.speak(message)
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Chinook::Capistrano::Campfire.load_into(Capistrano::Configuration.instance)
end
