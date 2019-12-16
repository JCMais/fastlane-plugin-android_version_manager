require "fastlane/action"
require "semantic"

require_relative "../helper/android_version_manager_helper"

module Fastlane
  module Actions
    # To Share a Value
    module SharedValues
      ANDROID_VERSION_NAME ||= :ANDROID_VERSION_NAME
    end

    class AndroidIncrementVersionNameAction < Action
      def self.run(params)
        UI.message("Param app_project_dir: #{params[:app_project_dir]}")
        UI.message("Param version_name: #{params[:version_name]}")
        UI.message("Param increment_type: #{params[:increment_type]}")
        UI.message("Param key: #{params[:key]}")

        file_path = "#{params[:app_project_dir]}/build.gradle"
        increment_type = params[:increment_type].to_sym

        # We can expect version_code to be an existing and valid version code
        version_name = Helper::AndroidVersionManagerHelper.get_version_name_from_gradle_file(file_path, params[:key])

        param_version_name = params[:version_name]
        unless param_version_name.nil?
          begin
            param_version_name = Semantic::Version.new(param_version_name)
          rescue Exception # rubocop:disable RescueException
            raise $!, "Error parsing version name #{param_version_name}: #{$!}", $!.backtrace
          end
        end
        new_version_name = param_version_name || version_name.increment!(increment_type)

        if new_version_name <= version_name
          UI.important("New version name is not greater than the current one")
        end

        Helper::AndroidVersionManagerHelper.set_key_value_on_gradle_file(file_path, params[:key], new_version_name.to_s)

        Actions.lane_context[Fastlane::Actions::SharedValues::ANDROID_VERSION_NAME] = new_version_name

        return new_version_name
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Increments the version name of the android project"
      end

      def self.details
        "Based on the provided params, increments the version name and returns their new value"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_project_dir,
                                       env_name: "FL_ANDROID_INCREMENT_VERSION_NAME_APP_PROJECT_DIR",
                                       description: "The path to the application source folder in the Android project (default: android/app)",
                                       optional: true,
                                       type: String,
                                       default_value: "android/app",
                                       verify_block: proc do |value|
                                         # Not using File.exist?("#{value}/build.gradle") because it does not handle globs
                                         UI.user_error!("Couldn't find build.gradle file at path '#{value}'") unless Dir["#{value}/build.gradle"].any?
                                       end),
          FastlaneCore::ConfigItem.new(key: :key,
                                       env_name: "FL_ANDROID_INCREMENT_VERSION_NAME_KEY",
                                       description: "The property key",
                                       optional: true,
                                       type: String,
                                       default_value: "versionName"),
          FastlaneCore::ConfigItem.new(key: :increment_type,
                                       env_name: "FL_ANDROID_INCREMENT_VERSION_NAME_INCREMENT_TYPE",
                                       description: "The type of increment to make, can be one of: patch, minor, major",
                                       optional: true,
                                       type: String,
                                       default_value: "patch",
                                       verify_block: proc do |value|
                                         UI.user_error!("Increment type of #{value} is not valid") unless ['patch', 'minor', 'major'].include?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :version_name,
                                       env_name: "FL_ANDROID_GET_VERSION_CODE_VERSION_NAME",
                                       description: "Change to a specific version name instead of just incrementing",
                                       optional: true,
                                       is_string: false),
        ]
      end

      def self.output
        [
          ["ANDROID_VERSION_NAME", "The new version name"],
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
        "The Android app new version name"
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
