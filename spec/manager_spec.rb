require 'spec_helper'

describe Specjour::Manager do
  describe "#available_for?" do
    it "is available for all projects by default" do
      subject.available_for?(rand.to_s).should be_true
    end

    it "is available for one project" do
      manager = Specjour::Manager.new :registered_projects => %w(one)
      manager.available_for?('one').should be_true
    end

    it "is available for many projects" do
      manager = Specjour::Manager.new :registered_projects => %w(one two)
      manager.available_for?('one').should be_true
      manager.available_for?('two').should be_true
    end
  end
  
  describe ".bundle_install" do
    let :manager do
      stub.instance_of(Specjour::Manager).project_path { "/tmp" }
      
      stub(Dir).chdir(anything) { |args|
        args.last.call # This yields to the block for Dir.chdir()
      }

      manager = Specjour::Manager.new
      stub(manager).project_path { "blah" }
      mock(manager).system('bundle lock')
      
      manager
    end
    
    it "should perform a bundle lock" do
      stub(manager).system('bundle check > /dev/null') { true }

      manager.bundle_install
    end
    
    it "should check if there are gems required" do
      mock(manager).system('bundle check > /dev/null') { true }
      
      manager.bundle_install    
    end

    context "when gems are required" do
      before :each do
        # Not a before :all as it needs to hook into the let hook above
        
        stub(manager).system('bundle check > /dev/null') { false }
      end
      
      context "and there is a bundler YAML file" do
        before :each do
          mock(File).exists?(".specjour/bundler") { true }
          mock(File).read(".specjour/bundler") { "" }
          mock(YAML)::load(anything) {
            { 'command' => "do it" }
          }
        end
        
        it "should get the bundle command from the YAML file" do
          mock(manager).system('do it > /dev/null')
          manager.bundle_install        
        end
      end
      
      context "and there is no bundler YAML file" do
        before :each do
          mock(File).exists?(".specjour/bundler") { false }
        end

        it "should perform a bundle install" do
          mock(manager).system('bundle install > /dev/null')
          manager.bundle_install        
        end        
      end
    end
  end
end
