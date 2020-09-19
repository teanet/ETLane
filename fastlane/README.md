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
### ios beta
```
fastlane ios beta
```
Push a new beta build to TestFlight
### ios metadata
```
fastlane ios metadata
```

### ios notify_changes
```
fastlane ios notify_changes
```

### ios new_version
```
fastlane ios new_version
```

### ios increment_and_push
```
fastlane ios increment_and_push
```

### ios rlz_minor
```
fastlane ios rlz_minor
```

### ios rlz
```
fastlane ios rlz
```

### ios commit_bump
```
fastlane ios commit_bump
```

### ios add_group_to_tf_build
```
fastlane ios add_group_to_tf_build
```

### ios first_time
```
fastlane ios first_time
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
