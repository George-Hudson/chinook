module Chinook
  module Capistrano
  end
end

%w(campfire passenger ping slack symlink).each do |m|
  require "chinook/capistrano/#{m}"
end
