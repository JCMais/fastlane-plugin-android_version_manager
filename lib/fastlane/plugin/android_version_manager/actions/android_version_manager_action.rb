require 'fastlane/action'
require_relative '../helper/android_version_manager_helper'

module Fastlane
  module Actions
    class AndroidVersionManagerAction < Action
      def self.run(params)
        UI.message("The android_version_manager plugin is working!")
      end

      def self.description
        "Android's App Version Managment"
      end

      def self.authors
        ["Jonathan Cardoso Machado"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_project_dir,
                                  env_name: "ANDROID_VERSIONING_APP_PROJECT_DIR",
                               description: "The path to the application source folder in the Android project (default: android/app)",
                                  optional: true,
                                      type: String,
                             default_value: "android/app"),
          FastlaneCore::ConfigItem.new(key: :key,
                               description: "The property key",
                                      type: String)

        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
