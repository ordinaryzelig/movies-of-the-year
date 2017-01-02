module DB

  module_function

  def connect
    ActiveRecord::Base.establish_connection(
      :adapter => "sqlite3",
      :database => path,
    )
  end

  def reset
    require 'fileutils'
    FileUtils.rm(path, force: true)
    schema
  end

  def path
    __dir__ + "/movies.#{ENV.fetch('MOTY_ENV')}.sqlite3"
  end

  def schema
    connect
    require_relative 'schema'
  end

end

