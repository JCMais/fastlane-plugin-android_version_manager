# android_version_manager plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-android_version_manager)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-android_version_manager`, add it to your project by running:

```bash
fastlane add_plugin android_version_manager
```

## About android_version_manager

Android's App Version Managment

This plugin enables you to more easily manage Android app versioning with fastlane.

### Available Actions

Read each action metadata on their respective source code:

#### [android_get_value_from_build_action](./lib/fastlane/plugin/android_version_manager/actions/android_get_value_from_build_action.rb)

#### [android_get_version_code_action](./lib/fastlane/plugin/android_version_manager/actions/android_get_version_code_action.rb)

#### [android_get_version_name_action](./lib/fastlane/plugin/android_version_manager/actions/android_get_version_name_action.rb)

#### [android_increment_version_code_action](./lib/fastlane/plugin/android_version_manager/actions/android_increment_version_code_action.rb)

#### [android_increment_version_name_action](./lib/fastlane/plugin/android_version_manager/actions/android_increment_version_name_action.rb)

### Version Control

This plugin does not provide any functionality related to version control. This was intentional because that can be easily implemented on the lane directly, for example, just use the following actions:
1. [ensure_git_status_clean](https://docs.fastlane.tools/actions/ensure_git_status_clean/)
2. [git_tag_exists](https://docs.fastlane.tools/actions/git_tag_exists/)
2. [git_add](https://docs.fastlane.tools/actions/git_add/)
2. [git_commit](https://docs.fastlane.tools/actions/git_commit/)
4. [add_git_tag](https://docs.fastlane.tools/actions/add_git_tag/)
3. [push_to_git_remote](https://docs.fastlane.tools/actions/push_to_git_remote/)

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.


## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).

## Development

After cloning the repo, run:

```bash
bundle install --path vendor/bundle
```

### Run tests for this plugin

To run both the tests, and code style validation, run

```bash
bundle exec rake
```

To automatically fix many of the styling issues, use
```bash
bundle exec rubocop -a
```

### Releasing

1. increment version at [`./lib/fastlane/plugin/android_version_manager/version.rb`](./lib/fastlane/plugin/android_version_manager/version.rb).
2. commit changes
3. run:
```bash
bundle exec rake release
```
