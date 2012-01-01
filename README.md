## Process

* export calendar into `movies.ics`.
* `ruby import.rb`.
* `ruby watched_before`
* `rake best_of[year]` ('new' movies rated 4 - 5)
* `rake worst_of[year] ('new' movies rated 1 - 2)

## Database

* Stored in local SQLite3 DB.
* Uses ActiveRecord.
* Just require db.rb.
* schema.rb will build DB.
* `rake reset` clears data out of DB.
* testing uses separate DB.
