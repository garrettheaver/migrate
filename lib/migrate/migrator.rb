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

          execute(path)
          _versions.insert({
            migration: File.basename(path)
          })

          yield path

        end # map
      end # transaction

      required
    end

    # Two types of migrations are currently supported. Simple SQL files and
    # executable files of any kind. SQL files are simply executed against the
    # db. Executable files are called with the first argument the db connection
    # uri. If the caller has given us a migration to perform but we have no
    # idea how to execute it the safest thing to do is throw an error and let
    # the entire operation rollback.

    def execute(path)
      @db.transaction do
        if false == File.exists?(path)
          raise ArgumentError, "#{path} not found"
        elsif '.sql' == File.extname(path)
          @db << File.read(path)
        elsif File.executable?(path)
          %x(#{path} #{@db.uri})
        else
          raise ArgumentError, "#{path} not valid"
        end
      end
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

  end
end

