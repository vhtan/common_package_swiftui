import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/common/cubit/generic_cubit_state.dart';
import 'package:mvvm_cubit/common/widget/drop_down.dart';
import 'package:mvvm_cubit/common/widget/primary_button.dart';
import 'package:mvvm_cubit/common/widget/text_input.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_cubit.dart';
import 'package:mvvm_cubit/viewmodel/add_trip/add_trip_state.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddTripScreen();
}

class _AddTripScreen extends State<AddTripScreen> {
  @override
  void initState() {
    BlocProvider.of<AddTripCubit>(context).getReasonList();
    BlocProvider.of<AddTripCubit>(context).getVehicleTypeList();
    BlocProvider.of<AddTripCubit>(context).getGuardGuyList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddTripCubit, GenericCubitState<AddTripState>>(
      listener: (context, state) {
        switch (state.status) {
          case Status.success:
            context.read<MainCubit>().addNewTrip(state.data!.trip!);
            Navigator.pop(context);
          default:
            break;
        }
      },
      builder: (context, state) {
        return BlocBuilder<AddTripCubit, GenericCubitState<AddTripState>>(
          builder:
              (BuildContext context, GenericCubitState<AddTripState> state) {
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
                        if (state.data!.reasons != null)
                          DropDown<String>(
                            items: state.data!.reasons!,
                            onChanged: (value) => context
                                .read<AddTripCubit>()
                                .reasonChanged(value),
                          ),
                        const SizedBox(height: 20),
                        TextInput(
                          hint: 'Nhập điểm dừng',
                          labelText: 'Điểm dừng',
                          keyboardType: TextInputType.number,
                          onChanged: (value) => context
                              .read<AddTripCubit>()
                              .stopPlaceChanged(value),
                        ),
                        const SizedBox(height: 20),
                        TextInput(
                          hint: 'Nhập số tiền',
                          labelText: 'Số tiền',
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              context.read<AddTripCubit>().amountChanged(
                                    int.parse(value),
                                  ),
                        ),
                        const SizedBox(height: 20),
                        if (state.data!.vehicleTypes != null)
                          DropDown<String>(
                            items: state.data!.vehicleTypes!,
                            onChanged: (value) => context
                                .read<AddTripCubit>()
                                .vehicleChanged(value),
                          ),
                        const SizedBox(height: 20),
                        if (state.data!.guardGuys != null)
                          DropDown<String>(
                            items: state.data!.guardGuys!,
                            onChanged: (value) => context
                                .read<AddTripCubit>()
                                .guardChanged(value),
                          ),
                        const SizedBox(height: 20),
                        TextInput(
                          hint: 'Nhập biển số xe',
                          labelText: 'Biển số xe',
                          keyboardType: TextInputType.number,
                          onChanged: (value) => context
                              .read<AddTripCubit>()
                              .licensePlateChanged(value),
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          title: 'Gửi',
                          buttonHeight: 50,
                          onPressed: state.data?.isValid() == true
                              ? () {
                                  context.read<AddTripCubit>().createTrip();
                                }
                              : null,
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
