# Reference:
# https://github.com/fastlane/fastlane/blob/0c6a6d24098b9/fastlane/spec/actions_specs/increment_version_number_action_spec.rb#L1
require 'spec_helper'

require 'semantic'

describe Fastlane::Actions::AndroidGetVersionNameAction do
  def execute_lane_test(dir: '../**/app', key: nil)
    params = [
      "app_project_dir: \"#{dir}\","
    ]

    params.push("key: \"#{key}\",") unless key.nil?

    Fastlane::FastFile.new.parse("lane :test do
      android_get_version_name(
        #{params.join("\n")}
      )
    end").runner.execute(:test)
  end

  describe "Get version name correctly" do
    it "returns default versionName from build.gradle" do
      result = execute_lane_test
      expect(result).to eq("1.0.0")
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_NAME]).to eq(result)
    end

    it "should return custom def versionName from build.gradle" do
      result = execute_lane_test(key: "defVersionName")
      expect(result).to be_a_kind_of(Semantic::Version)
      expect(result.to_s).to eq("1.0.0")
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_NAME]).to eq(result)
    end
  end

  describe "Validate params and version code" do
    it "throws error for invalid app project dir" do
      expect do
        execute_lane_test(dir: "invalid")
      end.to raise_error("Couldn't find build.gradle file at path 'invalid'")
    end

    it "throws error for non existing field" do
      expect do
        execute_lane_test(key: "versionNameNotFound")
      end.to raise_error("Unable to find version name with key versionNameNotFound on file ../**/app/build.gradle")
    end

    it "throws error for invalid field" do
      expect do
        execute_lane_test(key: "versionNameInvalid")
      end.to raise_error("Error parsing version name with key versionNameInvalid on file ../**/app/build.gradle: 1.0.0abc is not a valid SemVer Version (http://semver.org)")
    end

    it "throws error for invalid def field" do
      expect do
        execute_lane_test(key: "defVersionNameInvalid")
      end.to raise_error("Error parsing version name with key defVersionNameInvalid on file ../**/app/build.gradle: 1.0.0abc is not a valid SemVer Version (http://semver.org)")
    end
  end
end
