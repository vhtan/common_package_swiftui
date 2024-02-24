import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/chatting/chat_message_response.dart';
import 'package:mvvm_cubit/data/model/sos_history_details/sos_history_details_response.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class SOSHistoryDetailsCubit extends Cubit<GenericCubitState<dynamic>> {
  final MainRepository repository;

  SOSHistoryDetailsCubit({required this.repository})
      : super(GenericCubitState.loading());

  Future<void> getSOSHistoryDetails(String id) async {
    emit(
      GenericCubitState.loading(),
    );
    try {
      final details = await repository.getSOSHistoryDetails(id);
      emit(GetSOSHistoryDetailsState(
          sosDetails: details, status: Status.success));
    } on DioException catch (e) {
      emit(
        GenericCubitState.failure(e.errorMessage),
      );
    }
  }
}

class SOSHistoryDetailsState extends GenericCubitState<dynamic> {
  const SOSHistoryDetailsState({required super.status});
}

class GetSOSHistoryDetailsState extends SOSHistoryDetailsState {
  final SOSHistoryDetailsResponse sosDetails;
  const GetSOSHistoryDetailsState({
    required this.sosDetails,
    required super.status,
  });
}

class DidSendSOSMessageSuccess extends SOSHistoryDetailsState {
  const DidSendSOSMessageSuccess({
    required super.status,
  });
}

class ChattingListSOSSuccess extends SOSHistoryDetailsState {
  final List<ChatMessageResponse> list;
  const ChattingListSOSSuccess({
    required this.list,
    required super.status,
  });
}
