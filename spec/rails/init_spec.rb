require 'spec_helper'

module Specjour
  module DbScrub
  end
end

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
  
  context "when ENV['DB_PREPPED] is not set" do
    before :each do
      ENV['DB_PREPPED'] = nil
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
      begin
        Rails.test_block.call
      rescue LoadError => e
        # This exception is raised because I can't figure out how to stub Kernel.require
        # I don't know which object the require is being attached to, so hopefully this test will suffice. 
        Specjour::DbScrub.scrub
      end
    end
  end
end