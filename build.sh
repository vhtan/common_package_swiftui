#!/bin/bash

# Define the environments (debug, staging, release)
environments=("release")

# Function to build for Android
build_android() {
  local environment="$1"
  echo "Building for Android - $environment"
  flutter build apk --$environment
}

# Function to build for iOS (Mac only)
build_ios() {
  local environment="$1"
  echo "Building and exporting IPA for iOS - $environment"
  flutter build ios --$environment

  # Define your Xcode project name
  project_name="Runner"
  
  # The path to your Xcode project directory
  project_path="ios/$project_name.xcworkspace"

  # The scheme and configuration to build (use Debug for development and Release for production)
  scheme="Runner"
  configuration="Release"
  
  # The name of the exported IPA file
  ipa_name="$project_name-$environment.ipa"
  
  # Path to the export directory
  export_path="build/ios/ipa"
  
  # Export the IPA using xcodebuild
  xcodebuild -workspace "$project_path" -scheme "$scheme" -configuration "$configuration" -archivePath "$export_path/$environment" archive
  xcodebuild -exportArchive -archivePath "$export_path/$environment.xcarchive" -exportOptionsPlist exportOptions.plist -exportPath "$export_path"

  # Rename the exported IPA file
  mv "$export_path/$scheme.ipa" "$export_path/$ipa_name"
}

# Loop through environments and build for Android and iOS
for environment in "${environments[@]}"; do
  # build_android "$environment"
  build_ios "$environment"
done

echo "Build completed"