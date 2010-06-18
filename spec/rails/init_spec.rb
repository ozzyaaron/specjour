require 'spec_helper'

module Specjour
  module DbScrub
  end
end

DO_NOT_REQUIRE = true

describe "Rails Initialiser" do
  before :all do
    ENV['PREPARE_DB'] = "true"
    
    stub(Specjour::DbScrub).scrub
    
    class Rails
      class << self; attr_accessor :configuration; end
      class << self; attr_accessor :test_block; end
    end
    
    config = Object.new
    stub(config).after_initialize { |args|
      object = Object.new
      Rails.test_block = args
      object
    }
    Rails.configuration = config
    
    require 'rails/init'
  end
  
  it "should have a test" do
    true.should be_true
  end
  
  context "when ENV['DB_PREPPED] is false" do
    before :each do
      ENV['DB_PREPPED'] = "false"
    end
    
    it "should not run the DB Scrub task" do
      dont_allow(Specjour::DbScrub).scrub
      Rails.test_block.call
    end
  end
  
  context "when ENV['DB_PREPPED'] is set" do
    before :each do
      ENV['DB_PREPPED'] = "true"
    end
    
    it "should run the DB Scrub task" do
      mock(Specjour::DbScrub).scrub
      Rails.test_block.call
    end
  end
end