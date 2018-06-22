require "multiverse/generators"
require "multiverse/railtie"
require "multiverse/version"

module Multiverse
  class << self
    attr_writer :db

    def db
      @db ||= ENV["DB"].presence
    end

    def db_dir
      db_dir = db ? "db/#{db}" : "db"
      abort "Unknown DB: #{db}" unless Dir.exist?(db_dir)
      db_dir
    end

    def record_class
      if db
        record_class = parent_class_name.safe_constantize
        abort "Missing model: #{parent_class_name}" unless record_class
        record_class
      else
        ActiveRecord::Base
      end
    end

    def parent_class_name
      "#{db.camelize}Record"
    end

    def migrate_path
      Rails.application.paths["#{db_dir}/migrate"].to_a.presence || ["#{db_dir}/migrate"]
    end
  end
end
