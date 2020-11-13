defVersionCode = 1 // comment
defVersionCodeInvalid = "a" // comment

defVersionName = "1.0.0" // comment
defVersionNameInvalid = "1.0.0abc" // comment

android {
  compileSdkVersion(24)
  buildToolsVersion("24.0.2")
  defaultConfig {
    applicationIdSuffix = ""
    minSdkVersion(14)
    targetSdkVersion(22)
    versionCode = 12345 // comment
    versionCodeInvalid = "a" // comment
    versionName = "1.0.0" // comment
    defVersionNameMajor = "1" // comment
    defVersionNameMajorMinor = "1.0" // comment
    versionNameInvalid = "1.0.0abc" // comment
  }
}
