import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/stop_point/stop_point_response.dart';
import 'package:mvvm_cubit/view/main/widget/duty_container.dart';
import 'package:mvvm_cubit/view/main/widget/duty_info_widget.dart';

class TripContainer extends StatefulWidget {
  const TripContainer({
    super.key,
    required this.itineraries,
    required this.onPressed,
  });

  final List<StopPointResponse> itineraries;
  final VoidCallback onPressed;

  @override
  State<TripContainer> createState() => _TripContainer();
}

class _TripContainer extends State<TripContainer> {
  List<StopPointResponse> _itineraries = [];
  VoidCallback _onPressed = () {};

  @override
  void initState() {
    super.initState();
    _itineraries = widget.itineraries;
    _onPressed = widget.onPressed;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        const TripInfo(),
        _buildPanel(),
      ]),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: 0,
      children: _itineraries.map<ExpansionPanelRadio>(
        (StopPointResponse item) {
          return ExpansionPanelRadio(
            value: item.id,
            headerBuilder: (context, isExpanded) => ListTile(
              title: Text(
                item.stopPointType ?? '',
                style: headLine2,
              ),
            ),
            body: DutyContainer(
              stopPoint: item,
              onPressed: _onPressed,
            ),
          );
        },
      ).toList(),
    );
  }
}
