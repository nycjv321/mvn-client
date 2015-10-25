require 'spec_helper'
require 'securerandom'
include RSpec
system_temp = Dir.tmpdir
tmp_dir = system_temp + '/' + SecureRandom.hex

describe Mvn::Client do

  describe '.create' do
    it 'creates mvn projects' do
      Mvn::Client.create(tmp_dir, 'test_group_id', 'test_artifact_id')
      expect(File.exist? tmp_dir + "/#{'test_artifact_id'}/pom.xml").to be_truthy
    end

    before(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end

  describe '#version=' do
    it 'updates the project\'s version number' do
      Mvn::Client.create(tmp_dir, 'test_group_id', 'test_artifact_id')
      maven = Mvn::Client.new(tmp_dir, 'test_artifact_id')
      new_version = 'blah'
      maven.version = new_version
      expect(maven.version).to eq(new_version)
    end
    before(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
    after(:all) do
      FileUtils.rm_rf(tmp_dir)
    end
  end
end

