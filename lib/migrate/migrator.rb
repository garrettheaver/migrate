module Migrate
  class Migrator

    def initialize(db)
      @db = db
    end

    # apply any missing migrations
    def apply(scripts)
      existing = _versions.select(:migration).map{ |v| v[:migration] }
      required = scripts.select{ |s| !existing.include?(File.basename(s)) }

      # Apply all migrations inside a single transaction to ensure the
      # operation is an all or nothing event. After each migration is
      # applied we update the _versions table to keep track of which
      # migrations have already been executed.

      @db.transaction do
        required.each do |path|
          @db << File.read(path)

          _versions.insert({
            migration: File.basename(path)
          })

          yield path
        end
      end

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
        @db << File.read(File.expand_path("../versions.sql", __FILE__))
      end
    end

  end
end

