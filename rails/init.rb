if ENV['PREPARE_DB']
  Rails.configuration.after_initialize do
    unless ENV['DB_PREPPED']
      require 'specjour/db_scrub'
      Specjour::DbScrub.scrub
    end
  end
end
