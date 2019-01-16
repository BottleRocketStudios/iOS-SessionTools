#!/bin/sh
security delete-keychain ios-build.keychain

# Provisioning profiles not required for macOS development (the only place we're signing)
#rm -f "~/Library/MobileDevice/Provisioning Profiles/$PROFILE_NAME.mobileprovision"
