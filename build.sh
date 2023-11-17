#!/bin/bash

environments=("dev")

build_android() {
  local environment="$1"
  echo "Building for Android - $environment"
  flutter build apk --$environment
}

build_ios() {
  local environment="$1"
  echo "Building and exporting IPA for iOS - $environment"
  # flutter build ios --$environment
  flutter build ios --dart-define=env=$dev

  project_name="Runner"
  
  project_path="ios/$project_name.xcworkspace"

  scheme="Runner"
  configuration="Debug"
  
  ipa_name="$project_name-$environment.ipa"
  
  export_path="build/ios/ipa"
  echo "project_path $project_path"
  echo "scheme $scheme"
  echo "configuration $configuration"
  echo "export_path $export_path"
  echo "environment $environment"

  xcodebuild -workspace "$project_path" -scheme "$scheme" -configuration "$configuration" -archivePath "$export_path/$environment" archive
  xcodebuild -exportArchive -archivePath "$export_path/$environment.xcarchive" -exportOptionsPlist exportOptions.plist -exportPath "$export_path"


  # xcodebuild -exportArchive -archivePath "path/to/your.xcarchive" -exportPath "path/to/export" -exportOptionsPlist "path/to/ExportOptions.plist"
  # xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Debug -archivePath build/ios/ipa/dev archive

  # mv "$export_path/$scheme.ipa" "$export_path/$ipa_name"
}

for environment in "${environments[@]}"; do
  build_ios "$environment"
done

echo "Build completed"