# This source code is based on this one:
# https://github.com/otkmnb2783/fastlane-plugin-android_versioning/blob/a9dc02d69a8c3a106d00b52ace78d4a763baf6af/lib/fastlane/plugin/android_versioning/actions/get_value_from_build.rb#L1
require "fileutils"

module Fastlane
  module Actions
    class AndroidGetValueFromBuildAction < Action
      def self.run(params)
        app_project_dir ||= params[:app_project_dir]
        value, _line, _line_index = Helper::AndroidVersionManagerHelper.get_key_from_gradle_file("#{app_project_dir}/build.gradle", params[:key])
        return value
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_project_dir,
                                       description: "The path to the application source folder in the Android project, the one that contains the build.gradle file (default: android/app)",
                                       optional: true,
                                       type: String,
                                       default_value: "android/app",
                                       verify_block: proc do |value|
                                         # Not using File.exist?("#{value}/build.gradle") because it does not handle globs
                                         UI.user_error!("Couldn't find build.gradle file at path '#{value}'") unless Dir["#{value}/build.gradle"].any?
                                       end),
          FastlaneCore::ConfigItem.new(key: :key,
                                       description: "The property key to retrieve the value from",
                                       type: String),
        ]
      end

      def self.authors
        ["Jonathan Cardoso", "@_jonathancardos", "JCMais"]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
