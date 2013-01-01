ENV['MOTY_ENV'] = 'test'

require 'bundler/setup'
Bundler.require(:default, ENV['MOTY_ENV'].to_sym)

require 'minitest/autorun'

require_relative '../models'
