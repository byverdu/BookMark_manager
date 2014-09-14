require "data_mapper"

#DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, ENV['DATABASE_URL'])

require_relative './models/link'
require_relative './models/tag'
require_relative './models/user'

DataMapper.finalize

#DataMapper.auto_upgrade!