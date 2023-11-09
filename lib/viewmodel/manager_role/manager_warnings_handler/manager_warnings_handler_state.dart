// ignore_for_file: must_be_immutable

import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/chatting/chat_message_response.dart';
import 'package:mvvm_cubit/data/model/warning_details/warning_details_response.dart';

class ManagerWarningsHandlerState extends GenericCubitState<dynamic> {
  const ManagerWarningsHandlerState({required super.status});
}

class GetWarningDetailsSuccess extends ManagerWarningsHandlerState {
  WarningDetailsResponse warningDetails;
  GetWarningDetailsSuccess(
      {required this.warningDetails, required super.status});
}

class ProcessWarningSuccess extends ManagerWarningsHandlerState {
  const ProcessWarningSuccess({required super.status});
}

class ChattingListWarningSuccess extends ManagerWarningsHandlerState {
  final List<ChatMessageResponse> list;
  const ChattingListWarningSuccess({
    required this.list,
    required super.status,
  });
}
