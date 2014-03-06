module Chinook
  module Capistrano
  end
end

%w(campfire passenger ping).each { |m| require "chinook/capistrano/#{m}" }
