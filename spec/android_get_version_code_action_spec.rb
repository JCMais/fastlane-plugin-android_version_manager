# Reference:
# https://github.com/fastlane/fastlane/blob/0c6a6d24098b9/fastlane/spec/actions_specs/increment_version_number_action_spec.rb#L1
require 'spec_helper'

describe Fastlane::Actions::AndroidGetVersionCodeAction do
  def execute_lane_test_kts(dir: '../**/kts', key: nil)
    execute_lane_test(dir: dir, key: key)
  end

  def execute_lane_test(dir: '../**/app', key: nil)
    params = [
      "app_project_dir: \"#{dir}\","
    ]

    params.push("key: \"#{key}\",") unless key.nil?

    Fastlane::FastFile.new.parse("lane :test do
      android_get_version_code(
        #{params.join("\n")}
      )
    end").runner.execute(:test)
  end

  describe "Get version code correctly" do
    it "returns default versionCode from build.gradle" do
      result = execute_lane_test
      expect(result).to eq(12_345)
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_CODE]).to eq(result)
    end

    it "returns default versionCode from build.gradle.kts" do
      result = execute_lane_test_kts
      expect(result).to eq(12_345)
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_CODE]).to eq(result)
    end

    it "returns custom def versionCode from build.gradle" do
      result = execute_lane_test(key: "defVersionCode")
      expect(result).to eq(1)
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_CODE]).to eq(result)
    end

    it "returns custom def versionCode from build.gradle.kts" do
      result = execute_lane_test_kts(key: "defVersionCode")
      expect(result).to eq(1)
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_CODE]).to eq(result)
    end
  end

  describe "Validate params and version code" do
    it "throws error for invalid app project dir" do
      expect do
        execute_lane_test(dir: "invalid")
      end.to raise_error("Couldn't find build.gradle or build.gradle.kts file at path 'invalid'")
    end

    it "throws error for non existing field" do
      expect do
        execute_lane_test(key: "versionCodeNotFound")
      end.to raise_error("Unable to find version code with key versionCodeNotFound on file ../**/app/build.gradle")
    end

    it "throws error for non existing field in kts file" do
      expect do
        execute_lane_test_kts(key: "versionCodeNotFound")
      end.to raise_error("Unable to find version code with key versionCodeNotFound on file ../**/kts/build.gradle.kts")
    end

    it "throws error for invalid field" do
      expect do
        execute_lane_test(key: "versionCodeInvalid")
      end.to raise_error("Version code with key versionCodeInvalid on file ../**/app/build.gradle is invalid, it must be an integer")
    end

    it "throws error for invalid field in kts file" do
      expect do
        execute_lane_test_kts(key: "versionCodeInvalid")
      end.to raise_error("Version code with key versionCodeInvalid on file ../**/kts/build.gradle.kts is invalid, it must be an integer")
    end

    it "throws error for invalid def field" do
      expect do
        execute_lane_test(key: "defVersionCodeInvalid")
      end.to raise_error("Version code with key defVersionCodeInvalid on file ../**/app/build.gradle is invalid, it must be an integer")
    end

    it "throws error for invalid def field in kts file" do
      expect do
        execute_lane_test_kts(key: "defVersionCodeInvalid")
      end.to raise_error("Version code with key defVersionCodeInvalid on file ../**/kts/build.gradle.kts is invalid, it must be an integer")
    end
  end
end
