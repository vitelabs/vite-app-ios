fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios vite
```
fastlane ios vite
```
Push a new beta build to TestFlight
### ios vite_appstore
```
fastlane ios vite_appstore
```

### ios vite_test
```
fastlane ios vite_test
```

### ios vite_premainnet
```
fastlane ios vite_premainnet
```

### ios vite_enterprise
```
fastlane ios vite_enterprise
```

### ios match_profile
```
fastlane ios match_profile
```

### ios increment_build_number_and_push_git
```
fastlane ios increment_build_number_and_push_git
```

### ios push_git
```
fastlane ios push_git
```
push git local code
### ios pr
```
fastlane ios pr
```
create new pr in github argument base is base branch
### ios upload_dysm
```
fastlane ios upload_dysm
```
upload to Beta by Crashlytics
### ios vite_for_qa
```
fastlane ios vite_for_qa
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
