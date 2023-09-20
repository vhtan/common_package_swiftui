import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/drop_down.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/trip.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_cubit.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';

typedef DidAddTrip<T> = void Function(T value);

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddTripScreen();
}

class _AddTripScreen extends State<AddTripScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTripCubit, GenericCubitState<Trip>>(
      listener: (context, state) {
        switch (state.status) {
          case Status.success:
            context.read<MainCubit>().addNewTrip(state.data!);
            Navigator.pop(context);
          default:
            break;
        }
      },
      builder: (context, state) {
        return BlocBuilder<AddTripCubit, GenericCubitState<Trip>>(
          builder: (BuildContext context, GenericCubitState<Trip> state) {
            return Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Thêm phiếu yêu cầu',
                                style: headLine1,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                color: Colors.black,
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        DropDown<String>(
                          items: const [
                            'Mục đích',
                            'Đổ xăng',
                            'Sửa xe',
                            'Mục đích khác'
                          ],
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        const TextInput(
                          hint: 'Nhập điểm dừng',
                          labelText: 'Điểm dừng',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        const TextInput(
                          hint: 'Nhập số tiền',
                          labelText: 'Số tiền',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        DropDown<String>(
                          items: const [
                            'Loại xe',
                            'For',
                            'Toyota',
                            'Chevrolet'
                          ],
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        DropDown<String>(
                          items: const ['Bảo vệ', 'For', 'Toyota', 'Chevrolet'],
                          onChanged: (value) {},
                        ),
                        const SizedBox(height: 20),
                        const TextInput(
                          hint: 'Nhập biển số xe',
                          labelText: 'Biển số xe',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          title: 'Gửi',
                          buttonHeight: 50,
                          onPressed: () {
                            context.read<AddTripCubit>().createTrip();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
