require 'spec_helper'

class CustomException < RuntimeError
end

def boo
  raise CustomException, 'fails'
end

describe Specjour::Worker do
  it "fails" do
    boo
  end
  
  it "should initialise the environment variables" do
    Specjour::Worker.new("", "", 3, "")
    
    ENV['PREPARE_DB'].should == 'true'
    ENV['RSPEC_COLOR'].should == 'true'
    ENV['TEST_ENV_NUMBER'].should == '3'
    ENV['DB_PREPPED'].should == 'false'
  end
end
