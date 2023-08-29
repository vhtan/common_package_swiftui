import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/data/model/container/container_view_status.dart';

class ContainerCubit extends Cubit<ContainerViewStatus> {
  ContainerCubit() : super(ContainerViewStatus.route);

  void showRoute() {
    emit(ContainerViewStatus.route);
  }

  void showAccount() {
    emit(ContainerViewStatus.account);
  }
}
