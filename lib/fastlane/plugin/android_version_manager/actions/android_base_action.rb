require "fastlane/action"
require_relative "../helper/android_version_manager_helper"

module Fastlane
  module Actions
    class AndroidBaseAction < Action
      def self.authors
        ["Jonathan Cardoso", "@_jonathancardos", "JCMais", "Nicolas Verinaud"]
      end

      def self.is_supported?(platform)
        platform == :android
      end

      def self.app_project_dir_action
        FastlaneCore::ConfigItem.new(
          key: :app_project_dir,
          env_name: "FL_ANDROID_GET_VERSION_CODE_APP_PROJECT_DIR",
          description: "The path to the application source folder in the Android project (default: android/app)",
          optional: true,
          type: String,
          default_value: "android/app",
          verify_block: proc do |value|
            UI.user_error!("Couldn't find build.gradle or build.gradle.kts file at path '#{value}'") unless Helper::AndroidVersionManagerHelper.build_gradle_exists?(value)
          end
        )
      end

      def self.find_build_gradle(app_project_dir)
        Helper::AndroidVersionManagerHelper.find_build_gradle(app_project_dir)
      end
    end
  end
end
