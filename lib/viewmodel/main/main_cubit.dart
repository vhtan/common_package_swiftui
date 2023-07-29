import 'package:mvvm_cubit/common/cubit/generic_cubit.dart';
import 'package:mvvm_cubit/data/model/main/delivery.dart';
import 'package:mvvm_cubit/repository/main/main_repository.dart';

class MainCubit extends GenericCubit<Delivery> {
  final MainRepository mainRepository;

  MainCubit({required this.mainRepository});

  Future<void> getListDelivery() async {
    getItems(mainRepository.getListDelivery());
  }
}
