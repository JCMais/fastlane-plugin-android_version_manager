require "fastlane/action"
require_relative "../helper/android_version_manager_helper"

module Fastlane
  module Actions
    # To Share a Value
    module SharedValues
      ANDROID_VERSION_CODE ||= :ANDROID_VERSION_CODE
    end

    class AndroidIncrementVersionCodeAction < Action
      def self.run(params)
        UI.message("Param app_project_dir: #{params[:app_project_dir]}")
        UI.message("Param version_code: #{params[:version_code]}")
        UI.message("Param key: #{params[:key]}")

        file_path = "#{params[:app_project_dir]}/build.gradle"

        # We can expect version_code to be an existing and valid version code
        version_code = Helper::AndroidVersionManagerHelper.get_version_code_from_gradle_file(file_path, params[:key])
        new_version_code = params[:version_code] || version_code + 1

        if new_version_code <= version_code
          UI.user_error!("New version code must be greater than the current one")
        end

        Helper::AndroidVersionManagerHelper.set_key_value_on_gradle_file(file_path, params[:key], new_version_code)

        Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_CODE] = new_version_code

        return new_version_code
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Increments the version code of the android project"
      end

      def self.details
        "Based on the provided params, increments the version code and returns their new value"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_project_dir,
                                       env_name: "FL_ANDROID_INCREMENT_VERSION_CODE_APP_PROJECT_DIR",
                                       description: "The path to the application source folder in the Android project (default: android/app)",
                                       optional: true,
                                       type: String,
                                       default_value: "android/app",
                                       verify_block: proc do |value|
                                         # Not using File.exist?("#{value}/build.gradle") because it does not handle globs
                                         UI.user_error!("Couldn't find build.gradle file at path '#{value}'") unless Dir["#{value}/build.gradle"].any?
                                       end),
          FastlaneCore::ConfigItem.new(key: :key,
                                       env_name: "FL_ANDROID_INCREMENT_VERSION_CODE_KEY",
                                       description: "The property key",
                                       optional: true,
                                       type: String,
                                       default_value: "versionCode"),
          FastlaneCore::ConfigItem.new(key: :version_code,
                                      env_name: "FL_ANDROID_GET_VERSION_CODE_VERSION_CODE",
                                      description: "Change to a specific version instead of just incrementing",
                                      optional: true,
                                      is_string: false),
        ]
      end

      def self.output
        [
          ["ANDROID_VERSION_CODE", "The new version code"],
        ]
      end

      def self.category
        # https://github.com/fastlane/fastlane/blob/051e5012984d97257571a76627c1261946afb8f8/fastlane/lib/fastlane/action.rb#L6-L21
        :project
      end

      # def self.example_code
      #   [
      #     'version = android_increment_version_code(xcodeproj: "Project.xcodeproj")',
      #     'version = android_increment_version_code(
      #       xcodeproj: "Project.xcodeproj",
      #       target: "App"
      #     )'
      #   ]
      # end

      def self.return_value
        "The Android app new version code"
      end

      def self.return_type
        # https://github.com/fastlane/fastlane/blob/051e5012984d97257571a76627c1261946afb8f8/fastlane/lib/fastlane/action.rb#L23-L30
        :int
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
