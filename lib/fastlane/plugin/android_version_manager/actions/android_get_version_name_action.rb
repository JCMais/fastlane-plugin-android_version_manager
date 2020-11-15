require_relative 'android_base_action'
require_relative "../helper/android_version_manager_helper"

module Fastlane
  module Actions
    # To Share a Value
    module SharedValues
      ANDROID_VERSION_NAME ||= :ANDROID_VERSION_NAME
    end

    class AndroidGetVersionNameAction < AndroidBaseAction
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        UI.message("Parameter app_project_dir: #{params[:app_project_dir]}")
        UI.message("Parameter key: #{params[:key]}")

        file_path = find_build_gradle(params[:app_project_dir])
        # We can expect version_name to be an existing and valid semver version name
        version_name = Helper::AndroidVersionManagerHelper.get_version_name_from_gradle_file(file_path, params[:key])

        Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_NAME] = version_name

        return version_name
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Returns the version name of the android project"
      end

      def self.details
        "Based on the provided params, returns the value of the version name of the build.gradle file as a string"
      end

      def self.available_options
        [
          app_project_dir_action,
          FastlaneCore::ConfigItem.new(key: :key,
                                       env_name: "FL_ANDROID_GET_VERSION_CODE_KEY",
                                       description: "The property key",
                                       optional: true,
                                       type: String,
                                       default_value: "versionName"),
        ]
      end

      def self.output
        [
          ["ANDROID_VERSION_NAME", "The version code specified on the build.gradle file of the project"],
        ]
      end

      def self.category
        # https://github.com/fastlane/fastlane/blob/051e5012984d97257571a76627c1261946afb8f8/fastlane/lib/fastlane/action.rb#L6-L21
        :project
      end

      # def self.example_code
      #   [
      #     'version = get_version_name(xcodeproj: "Project.xcodeproj")',
      #     'version = get_version_name(
      #       xcodeproj: "Project.xcodeproj",
      #       target: "App"
      #     )'
      #   ]
      # end

      def self.return_value
        "The Android app version name"
      end

      def self.return_type
        # https://github.com/fastlane/fastlane/blob/051e5012984d97257571a76627c1261946afb8f8/fastlane/lib/fastlane/action.rb#L23-L30
        :int
      end
    end
  end
end
