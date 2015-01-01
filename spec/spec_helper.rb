ENV['MOTY_ENV'] = 'test'

require 'bundler/setup'
Bundler.require(:default, ENV['MOTY_ENV'].to_sym)

require_relative '../db/db'
DB.connect

require 'minitest/autorun'

require_relative '../models'
