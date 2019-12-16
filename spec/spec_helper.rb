$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))

require "simplecov"

# SimpleCov.minimum_coverage 95
SimpleCov.start

# This module is only used to check the environment is currently a testing env
module SpecHelper
end

require "fastlane" # to import the Action super class
require "fastlane/plugin/android_version_manager" # import the actual plugin

Fastlane.load_actions # load other actions (in case your plugin calls other actions or shared values)

# Cpy fixture to tmp folder to revert it after modifications done by tests
def save_fixtures
  FileUtils.mkdir_p("/tmp/fastlane")
  source = "./spec/fixtures"
  destination = "/tmp/fastlane"

  FileUtils.cp_r(source, destination)
end

# Revert the fixture to the original one
def revert_fixtures
  source = "/tmp/fastlane/fixtures"
  destination = "./spec"
  [
    "#{destination}/fixtures/app/build.gradle",
  ].each do |f|
    FileUtils.rm(f)
  end
  FileUtils.cp_r(source, destination)
  FileUtils.rm_r(source)
end

RSpec.configure do |config|
  config.filter_run_when_matching(:only)

  config.before(:each, { modifies_gradle: true }) do
    save_fixtures
  end

  config.after(:each, { modifies_gradle: true }) do
    revert_fixtures
  end
end
