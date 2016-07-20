# Migrate
A basic ruby tool for managing database migrations.

Two different types of migration are supported:

1. Simple SQL files
2. Any executable files

SQL migrations (any file with a `.sql` extension) simply get read and their contents executed against the database as a single statement. Any files which do not have a `.sql` extension but are marked as executable (`chmod +x`) will be invoked with the connection string to the database passed as their first and only parameter.

All migrations which are successfully applied are tracked in an `_versions` table. The `_versions` table is created on first execution of the tool. Only missing migrations (migrations not already tracked in `_versions`) will be applied any time the tool is run.

All migrations are executed within a single database transaction so either all the specified migrations apply successfully or they all get rolled back (assuming the database supports it).

To run the tool simply execute the `migrate` command passing the database connection string as the first parameter followed by a list of migration files to apply. e.g.
```shell
migrate postgres://localhost/mydb migrations/*.*
```

## Installing
Add the following to your Gemfile:
```ruby
gem 'migrate', git: 'https://github.com/garrettheaver/migrate.git'
```

## Supported Databases
Currently the following databases are supported by the tool. Pull requests to support others are always welcome.

* PostgreSQL (`postgres://<user>:<pass>@<host>/<database>`)

