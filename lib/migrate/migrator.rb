module Migrate
  class Migrator

    def initialize(db)
      @db = db
    end

    def ensure(scripts)
      existing = _versions.select(:migration).map{ |v| v[:migration] }
      required = scripts.select{ |s| !existing.include?(s) }

      @db.transaction do
        required.each do |m|
          @db << File.read(m)
          _versions.insert({ migration: m })
        end
      end

      required
    end

    private

    def _versions
      _create_versions unless _versions_exists?
      @db[:_versions]
    end

    def _versions_exists?
      @db.tables.include?(:_versions)
    end

    def _create_versions
      @db.transaction do
        @db << File.read(File.expand_path("../versions.sql", __FILE__))
      end
    end

  end
end

