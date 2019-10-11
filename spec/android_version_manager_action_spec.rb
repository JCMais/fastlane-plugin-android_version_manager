describe Fastlane::Actions::AndroidVersionManagerAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The android_version_manager plugin is working!")

      Fastlane::Actions::AndroidVersionManagerAction.run(nil)
    end
  end
end
