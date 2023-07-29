#!/bin/bash
set -e
dart pub get
dart pub run build_runner build --delete-conflicting-outputs
