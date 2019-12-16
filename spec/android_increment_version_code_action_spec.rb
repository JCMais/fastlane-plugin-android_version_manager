# Reference:
# https://github.com/fastlane/fastlane/blob/0c6a6d24098b9/fastlane/spec/actions_specs/increment_version_number_action_spec.rb#L1
require 'spec_helper'

describe Fastlane::Actions::AndroidIncrementVersionCodeAction do
  def execute_lane_test(dir: '../**/app', key: nil, version_code: nil)
    params = [
      "app_project_dir: \"#{dir}\","
    ]

    params.push("key: \"#{key}\",") unless key.nil?
    params.push("version_code: #{version_code},") unless version_code.nil?

    Fastlane::FastFile.new.parse("lane :test do
      android_increment_version_code(
        #{params.join("\n")}
      )
    end").runner.execute(:test)
  end

  describe "Increment version code correctly" do
    it "increments default versionCode on build.gradle", :modifies_gradle do
      result = execute_lane_test
      expect(result).to eq(12_346)
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_CODE]).to eq(result)
    end
    it "increments def versionCode on build.gradle", :modifies_gradle do
      result = execute_lane_test(key: "defVersionCode")
      expect(result).to eq(2)
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_CODE]).to eq(result)
    end
    it "increments versionCode on build.gradle to the specified amount", :modifies_gradle do
      result = execute_lane_test(version_code: 23_456)
      expect(result).to eq(23_456)
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_CODE]).to eq(result)
    end
  end
end
