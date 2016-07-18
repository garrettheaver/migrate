module Migrate
  class Migrator

    def initialize(db)
      @db = db
    end

    # Apply all missing migrations inside a single transaction to ensure the
    # operation is an all or nothing event. After each migration is applied we
    # update the _versions table to keep track of which migrations have already
    # been executed. Method yields path of each applied migration.

    def apply(scripts)
      existing = _versions.select(:migration).map{ |v| v[:migration] }
      required = scripts.select{ |s| !existing.include?(File.basename(s)) }

      @db.transaction do
        required.map do |path|

          # check the path actually exists before we try to use it
          raise ArgumentError, "#{path} not found" unless File.exists?(path)

          _execute(path)
          _versions.insert({
            migration: File.basename(path)
          })

          yield path

        end # map
      end # transaction

      required
    end

    private

    # get a reference to the _versions table
    def _versions
      _create_versions unless _versions_exists?
      @db[:_versions]
    end

    # check if the _versions table exists
    def _versions_exists?
      @db.tables.include?(:_versions)
    end

    # try to create the _versions table
    def _create_versions
      @db.transaction do
        filename = "../versions.#{@db.adapter_scheme}.sql"
        @db << File.read(File.expand_path(filename, __FILE__))
      end
    end

    # Two types of migrations are currently supported. Simple SQL files
    # and executable files of any kind. SQL files are simply executed
    # against the db. Executable files are called with the first argument
    # the db connection uri.

    def _execute(path)
      if '.sql' == File.extname(path)
        @db << File.read(path)
      elsif File.executable?(path)
        %x(#{path} #{@db.uri})
      else

        # If the caller has given us a migration to perform but we have
        # no idea how to execute it the safest thing to do is throw an
        # error and let the entire operation rollback.

        raise ArgumentError, "#{path} is invalid"

      end
    end

  end
end

