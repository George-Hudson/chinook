# Defines a task that will let a Slack channel know about a deploy.
require 'capistrano'
require 'slack-notifier'

module Chinook::Capistrano
  module Slack
    def self.load_into(configuration)
      configuration.load do
        namespace :chinook do
          desc 'Lets a Slack channel know about a deploy that has begun.'
          task :slack_start, except: { no_release: true } do
            unless exists?(:slack_channel) && exists?(:slack_token) && exists?(:slack_team)
              logger.info 'Cannot notify Slack without :slack_channel, :slack_token, and :slack_team. Skipping task.'
              next
            end

            project_name = fetch(:project_name, application)
            git_username = `git config user.name`.chomp

            message = "#{git_username} started a deploy of *#{project_name}* to *#{stage}* at #{Time.now.strftime('%r %Z')}."
            message = ":shipit: #{message}" if fetch(:slack_shipit)

            slack = ::Slack::Notifier.new(fetch(:slack_team),
                                          fetch(:slack_token))
            slack.channel = fetch(:slack_channel)
            slack.username = fetch(:slack_username)

            icon = fetch(:slack_icon_url)
            opts = { icon_url: icon } if icon
            slack.ping message, opts
          end

          desc 'Lets a Slack channel know about a deploy that is rolling back.'
          task :slack_rollback, except: { no_release: true } do
            unless exists?(:slack_channel) && exists?(:slack_token) && exists?(:slack_team)
              logger.info 'Cannot notify Slack without :slack_channel, :slack_token, and :slack_team. Skipping task.'
              next
            end

            project_name = fetch(:project_name, application)
            git_username = `git config user.name`.chomp

            message = "#{git_username}'s deploy of *#{project_name}* to *#{stage}* has been rolled back at #{Time.now.strftime('%r %Z')}."
            message = ":shipit: #{message}" if fetch(:slack_shipit)

            slack = ::Slack::Notifier.new(fetch(:slack_team),
                                          fetch(:slack_token))
            slack.channel = fetch(:slack_channel)
            slack.username = fetch(:slack_username)

            icon = fetch(:slack_icon_url)
            opts = { icon_url: icon } if icon
            slack.ping message, opts
          end

          desc 'Lets a Slack channel know about a deploy that has finished.'
          task :slack_end, except: { no_release: true } do
            unless exists?(:slack_channel) && exists?(:slack_token) && exists?(:slack_team)
              logger.info 'Cannot notify Slack without :slack_channel, :slack_token, and :slack_team. Skipping task.'
              next
            end

            project_name = fetch(:project_name, application)
            git_username = `git config user.name`.chomp

            message = "#{git_username}'s deploy of *#{project_name}* to *#{stage}* finished at #{Time.now.strftime('%r %Z')}."
            message = ":shipit: #{message}" if fetch(:slack_shipit)

            slack = ::Slack::Notifier.new(fetch(:slack_team),
                                          fetch(:slack_token))
            slack.channel = fetch(:slack_channel)
            slack.username = fetch(:slack_username)

            icon = fetch(:slack_icon_url)
            opts = { icon_url: icon } if icon
            slack.ping message, opts
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Chinook::Capistrano::Slack.load_into(Capistrano::Configuration.instance)
end
