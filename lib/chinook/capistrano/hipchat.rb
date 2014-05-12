# Defines a task that will let a HipChat channel know about a deploy.
require 'capistrano'
require 'hipchat'

module Chinook::Capistrano
  module HipChat
    def self.load_into(configuration)
      configuration.load do
        namespace :chinook do
          desc 'Lets a HipChat room know about a deploy that has begun.'
          task :hipchat_start, except: { no_release: true } do
            unless exists?(:hipchat_room) && exists?(:hipchat_token)
              logger.info 'Cannot notify HipChat without :hipchat_room and :hipchat_token. Skipping task.'
              next
            end

            project_name = fetch(:project_name, application)
            git_username = `git config user.name`.chomp

            message = "#{git_username} started a deploy of #{project_name} to #{stage} at #{Time.now.strftime('%r %Z')}."

            hipchat = ::HipChat::Client.new(fetch(:hipchat_token),
                                            api_version: 'v2')
            room = fetch(:hipchat_room)
            username = fetch(:hipchat_username, 'Deployment')
            hipchat[room].send(username, message, color: 'yellow')
          end

          desc 'Lets a HipChat channel know about a deploy that is rolling back.'
          task :hipchat_rollback, except: { no_release: true } do
            unless exists?(:hipchat_room) && exists?(:hipchat_token)
              logger.info 'Cannot notify HipChat without :hipchat_room and :hipchat_token. Skipping task.'
              next
            end

            project_name = fetch(:project_name, application)
            git_username = `git config user.name`.chomp

            message = "#{git_username}'s deploy of #{project_name} to #{stage} has been rolled back at #{Time.now.strftime('%r %Z')}."

            hipchat = ::HipChat::Client.new(fetch(:hipchat_token),
                                            api_version: 'v2')
            room = fetch(:hipchat_room)
            username = fetch(:hipchat_username, 'Deployment')
            hipchat[room].send(username, message, color: 'red')
          end

          desc 'Lets a HipChat channel know about a deploy that has finished.'
          task :hipchat_end, except: { no_release: true } do
            unless exists?(:hipchat_room) && exists?(:hipchat_token)
              logger.info 'Cannot notify HipChat without :hipchat_room and :hipchat_token. Skipping task.'
              next
            end

            project_name = fetch(:project_name, application)
            git_username = `git config user.name`.chomp

            message = "#{git_username}'s deploy of #{project_name} to #{stage} finished at #{Time.now.strftime('%r %Z')}."

            hipchat = ::HipChat::Client.new(fetch(:hipchat_token),
                                            api_version: 'v2')
            room = fetch(:hipchat_room)
            username = fetch(:hipchat_username, 'Deployment')
            hipchat[room].send(username, message, color: 'green')
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Chinook::Capistrano::HipChat.load_into(Capistrano::Configuration.instance)
end
