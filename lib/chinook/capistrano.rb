module Chinook
  module Capistrano
  end
end

%w(campfire passenger ping symlink).each { |m| require "chinook/capistrano/#{m}" }
