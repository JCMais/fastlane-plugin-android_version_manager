require "fileutils"

require "fastlane_core/ui/ui"
require "semantic"
require "tempfile"

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class AndroidVersionManagerHelper
      # class methods that you define here become available in your action
      # as `Helper::AndroidVersionManagerHelper.your_method`
      # Most actions code are here to follow this advice: https://docs.fastlane.tools/advanced/actions/#calling-other-actions
      def self.get_key_from_gradle_file(file_path, key)
        UI.message("Hello from the android_version_manager plugin helper - get_key_from_file!")

        regex = Regexp.new(/(?<key>#{key}\s+)(?<equals>\=[\s]*?)?(?<left>[\'\"]?)(?<value>[a-zA-Z0-9\.\_]+)(?<right>[\'\"]?)(?<comment>.*)/)
        value = ""
        line_found = nil
        line_found_index = nil
        found = false
        Dir.glob(file_path) do |path|
          UI.verbose("get_key_from_gradle_file - path: #{path}")
          UI.verbose("get_key_from_gradle_file - absolute_path: #{File.expand_path(path)}")
          begin
            File.open(path, "r") do |file|
              file.each_line do |line, index|
                unless line.match(regex) && !found
                  next
                end
                line_found = line
                line_found_index = index
                _key, _equals, _left, value, _right, _comment = line.match(regex).captures
                break
              end
              file.close
            end
          end
        end
        return value, line_found, line_found_index
      end

      def self.set_key_value_on_gradle_file(file_path, key, new_value)
        # this will do the search again, only because we need the values again
        value, _line_found, line_found_index = get_key_from_gradle_file(file_path, key)

        # https://stackoverflow.com/a/4174125/710693
        Dir.glob(file_path) do |path|
          Tempfile.open(".#{File.basename(path)}", File.dirname(path)) do |tempfile|
            UI.verbose("set_key_value_on_gradle_file - path: #{path}")
            UI.verbose("set_key_value_on_gradle_file - absolute_path: #{File.expand_path(path)}")
            File.open(path).each do |line, index|
              tempfile.puts(index == line_found_index ? line.sub(value, new_value.to_s) : line)
            end
            tempfile.close
            FileUtils.mv(tempfile.path, path)
          end
        end
      end

      def self.get_version_code_from_gradle_file(file_path, key)
        version_code, _line, _line_index = get_key_from_gradle_file(file_path, key)

        UI.message("Read version code: #{version_code.inspect}")

        # Error out if version_number is not set
        if version_code.nil? || version_code == ""
          UI.user_error!("Unable to find version code with key #{key} on file #{file_path}")
        end

        version_code = Helper::AndroidVersionManagerHelper.string_to_int(version_code)

        # Error out if version_number is invalid
        if version_code.nil?
          UI.user_error!("Version code with key #{key} on file #{file_path} is invalid, it must be an integer")
        end

        return version_code
      end

      def self.get_version_name_from_gradle_file(file_path, key)
        version_name, _line, _line_index = get_key_from_gradle_file(file_path, key)

        UI.message("Read version name: #{version_name.inspect}")

        # Error out if version_name is not set
        if version_name.nil? || version_name == ""
          UI.user_error!("Unable to find version name with key #{key} on file #{file_path}")
        end

        begin
          version_name = Semantic::Version.new(version_name)
        rescue Exception # rubocop:disable RescueException
          raise $!, "Error parsing version name with key #{key} on file #{file_path}: #{$!}", $!.backtrace
        end

        return version_name
      end

      def self.string_to_int(string)
        # without exceptions:
        # num = string.to_i
        # num if num.to_s == string
        Integer(string || "", 10)
      rescue ArgumentError
        nil
      end
    end
  end
end
