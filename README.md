build release : flutter build apk --release -t lib/main.dart --dart-define=env=prod
flutter build apk --release -t lib/main.dart --dart-define=env=dev
flutter build apk --release -t lib/main.dart --dart-define=env=stg