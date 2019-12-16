# Reference:
# https://github.com/fastlane/fastlane/blob/0c6a6d24098b9/fastlane/spec/actions_specs/increment_version_number_action_spec.rb#L1
require 'spec_helper'

describe Fastlane::Actions::AndroidIncrementVersionNameAction do
  def execute_lane_test(dir: '../**/app', key: nil, version_name: nil, increment_type: nil)
    params = [
      "app_project_dir: \"#{dir}\","
    ]

    params.push("key: \"#{key}\",") unless key.nil?
    params.push("version_name: \"#{version_name}\",") unless version_name.nil?
    params.push("increment_type: \"#{increment_type}\",") unless increment_type.nil?

    Fastlane::FastFile.new.parse("lane :test do
      android_increment_version_name(
        #{params.join("\n")}
      )
    end").runner.execute(:test)
  end

  describe "Increment version name correctly" do
    it "increments default versionName on build.gradle", :modifies_gradle do
      result = execute_lane_test
      expect(result).to be_a_kind_of(Semantic::Version)
      expect(result.to_s).to eq("1.0.1")
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_NAME]).to eq(result)
    end
    it "increments def versionName on build.gradle", :modifies_gradle do
      result = execute_lane_test(key: "defVersionName")
      expect(result).to be_a_kind_of(Semantic::Version)
      expect(result.to_s).to eq("1.0.1")
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_NAME]).to eq(result)
    end
    it "increments default versionName on build.gradle with patch bump", :modifies_gradle do
      result = execute_lane_test(increment_type: "patch")
      expect(result).to be_a_kind_of(Semantic::Version)
      expect(result.to_s).to eq("1.0.1")
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_NAME]).to eq(result)
    end
    it "increments default versionName on build.gradle with minor bump", :modifies_gradle do
      result = execute_lane_test(increment_type: "minor")
      expect(result).to be_a_kind_of(Semantic::Version)
      expect(result.to_s).to eq("1.1.0")
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_NAME]).to eq(result)
    end
    it "increments default versionName on build.gradle with major bump", :modifies_gradle do
      result = execute_lane_test(increment_type: "major")
      expect(result).to be_a_kind_of(Semantic::Version)
      expect(result.to_s).to eq("2.0.0")
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_NAME]).to eq(result)
    end
    it "increments versionCode on build.gradle to the specified amount", :modifies_gradle do
      result = execute_lane_test(version_name: "2.3.4")
      expect(result).to be_a_kind_of(Semantic::Version)
      expect(result.to_s).to eq("2.3.4")
      expect(Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_NAME]).to eq(result)
    end
  end

  describe "Validate params and version code" do
    it "show message if newer version name is lower than the current value", :modifies_gradle do
      expect(Fastlane::UI).to receive(:important).with("New version name is not greater than the current one")
      execute_lane_test(version_name: "0.0.1")
    end

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

    it "throws error for invalid increment type field" do
      expect do
        execute_lane_test(increment_type: "majora") # mask
      end.to raise_error("Increment type of majora is not valid")
    end
  end
end
