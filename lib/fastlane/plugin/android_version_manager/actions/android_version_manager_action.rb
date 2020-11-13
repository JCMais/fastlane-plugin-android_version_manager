require_relative 'android_base_action'
require_relative '../helper/android_version_manager_helper'

module Fastlane
  module Actions
    class AndroidVersionManagerAction < AndroidBaseAction
      def self.run(params)
        UI.message("The android_version_manager plugin is working!")
      end

      def self.description
        "Android's App Version Managment"
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
          app_project_dir_action
        ]
      end
    end
  end
end
