# Defines a task that will symlink directories into the deployed site.
require 'capistrano'

module Chinook::Capistrano
  module Symlink
    def self.load_into(configuration)
      configuration.load do
        namespace :chinook do
          desc 'Symlinks files or directories from shared into public.'
          task :symlink_shared_to_public, except: { no_release: true } do
            logger.info "Symlinking directories from shared into public."
            fetch(:public_directories, []).each do |directory|
              source = File.join(deploy_to, 'shared', directory)
              destination = File.join(release_path, 'public', directory)
              invoke_command "ln -nfs #{source} #{destination}", via: run_method
            end
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Chinook::Capistrano::Symlink.load_into(Capistrano::Configuration.instance)
end
