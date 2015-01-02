ActiveRecord::Schema.define do

  create_table :movies do |t|
    t.string  :name
    t.string  :sort_name
    t.date    :watched_on
    t.boolean :new_this_year
    t.integer :rating
    t.boolean :watched_before
  end

end
