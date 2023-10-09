import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/stop_point/stop_point_response.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/view/main/widget/stop_point_container.dart';
import 'package:mvvm_cubit/view/main/widget/trip_info_widget.dart';

class TripContainer extends StatefulWidget {
  const TripContainer({
    super.key,
    required this.trip,
    required this.onPressed,
  });

  final TripResponse trip;
  final VoidCallback onPressed;

  @override
  State<TripContainer> createState() => _TripContainer();
}

class _TripContainer extends State<TripContainer> {
  TripResponse? _trip;
  VoidCallback _onPressed = () {};

  @override
  void initState() {
    super.initState();
    _trip = widget.trip;
    _onPressed = widget.onPressed;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        TripInfo(
          tripCode: (_trip?.routeId)!,
          createBy: (_trip?.createBy)!,
          startDate: (_trip?.startTime?.date)!,
        ),
        _buildPanel(),
      ]),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: 0,
      children: (_trip?.routingDetails)!.map<ExpansionPanelRadio>(
        (StopPointResponse item) {
          return ExpansionPanelRadio(
            value: item.id,
            headerBuilder: (context, isExpanded) => ListTile(
              title: Text(
                item.stopPointType ?? '',
                style: headLine2,
              ),
            ),
            body: StopPointContainer(
              stopPoint: item,
              onPressed: _onPressed,
            ),
          );
        },
      ).toList(),
    );
  }
}
