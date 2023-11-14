import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/notification/notification_response.dart';

class NotificationState extends GenericCubitState<dynamic> {
  const NotificationState({required super.status});
}

// ignore: must_be_immutable
class GetNotificationListSuccess extends NotificationState {
  List<NotificationResponse> list;

  GetNotificationListSuccess({required super.status, required this.list});
}

class ReadNotificationSuccess extends NotificationState {
  const ReadNotificationSuccess({required super.status});
}

class DidReadNotification extends NotificationState {
  const DidReadNotification({required super.status});
}
