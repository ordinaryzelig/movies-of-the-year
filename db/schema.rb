# Create DB.

require_relative 'db'

ActiveRecord::Schema.define do

  create_table :movies do |t|
    t.string  :name
    t.string  :sort_name
    t.date    :watched_on
    t.date    :released_on
    t.integer :rating
    t.boolean :watched_before
  end

end
