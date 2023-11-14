import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/data/model/main/stop_point/stop_point_response.dart';
import 'package:mvvm_cubit/data/model/main/trip/trip_response.dart';
import 'package:mvvm_cubit/view/main/widget/stop_point_container.dart';
import 'package:mvvm_cubit/view/main/widget/trip_info_widget.dart';

class TripContainer extends StatefulWidget {
  const TripContainer({
    super.key,
    required this.trip,
    required this.onArrived,
    required this.onFinihed,
  });

  final TripResponse trip;
  final ValueChanged<StopPointResponse> onArrived;
  final ValueChanged<int> onFinihed;

  @override
  State<TripContainer> createState() => _TripContainer();
}

class _TripContainer extends State<TripContainer> {
  TripResponse? _trip;

  @override
  void initState() {
    super.initState();
    _trip = widget.trip;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: buildStopPointList(_trip?.routingDetails ?? []));
  }

  Column buildStopPointList(List<StopPointResponse> stopPoints) {
    return Column(
      children: [
        TripInfo(
          tripCode: (_trip?.routeId)!,
          createBy: (_trip?.createBy)!,
          startDate: (_trip?.startTime?.toDate)!,
        ),
        ...stopPoints.map(
          (stopPoint) {
            return StopPointContainer(
              stopPoint: stopPoint,
              onArrived: widget.onArrived,
              onFinished: widget.onFinihed,
            );
          },
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
