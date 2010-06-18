if ENV['PREPARE_DB']
  Rails.configuration.after_initialize do
    puts "ENV : #{ENV['DB_PREPPED']}"      
    unless ENV['DB_PREPPED'] == "false"
      require 'specjour/db_scrub' unless defined? DO_NOT_REQUIRE
      Specjour::DbScrub.scrub
    end
  end
end
