module Chinook::Capistrano; end

%w(campfire passenger ping).each { |m| require "chinook/capistrano/#{m}" }
