require_relative 'android_base_action'
require_relative '../helper/android_version_manager_helper'

module Fastlane
  module Actions
    class AndroidGetValueFromBuildAction < AndroidBaseAction
      def self.run(params)
        app_project_dir ||= params[:app_project_dir]
        file_path = find_build_gradle(app_project_dir)
        value, _line, _line_index = Helper::AndroidVersionManagerHelper.get_key_from_gradle_file(file_path, params[:key])
        return value
      end

      def self.available_options
        [
          app_project_dir_action,
          FastlaneCore::ConfigItem.new(key: :key,
                                       description: "The property key to retrieve the value from",
                                       type: String),
        ]
      end
    end
  end
end
