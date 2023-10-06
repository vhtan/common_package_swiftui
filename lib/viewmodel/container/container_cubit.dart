import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/data/model/container/menu_type.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class ContainerCubit extends Cubit<GenericCubitState<MenuType>> {
  final MainRepository repository;
  ContainerCubit({required this.repository})
      : super(GenericCubitState.loading());

  Future<void> menuAction(MenuType menuType) async {
    emit(
      GenericCubitState.success(menuType),
    );
  }
}
