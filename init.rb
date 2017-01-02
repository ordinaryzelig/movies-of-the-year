$VERBOSE = false # Shut up warnings

ENV['MOTY_ENV'] ||= 'dev'

require 'bundler/setup'
Bundler.require(:default, ENV['MOTY_ENV'].to_sym)

require_relative 'models'
