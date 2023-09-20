import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/duty.dart';
import 'package:mvvm_cubit/view/main/widget/duty_container.dart';
import 'package:mvvm_cubit/view/main/widget/duty_info_widget.dart';

class TripContainer extends StatefulWidget {
  const TripContainer({
    super.key,
    required this.itineraries,
    required this.onPressed,
  });

  final List<Duty> itineraries;
  final VoidCallback onPressed;

  @override
  State<TripContainer> createState() => _TripContainer();
}

class _TripContainer extends State<TripContainer> {
  List<Duty> _itineraries = [];
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
        (Duty item) {
          return ExpansionPanelRadio(
            value: item.id,
            headerBuilder: (context, isExpanded) => ListTile(
              title: Text(
                item.title,
                style: headLine2,
              ),
            ),
            body: DutyContainer(
              duty: item,
              onPressed: _onPressed,
            ),
          );
        },
      ).toList(),
    );
  }
}
