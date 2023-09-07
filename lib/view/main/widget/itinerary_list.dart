import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_style.dart';
import 'package:mvvm_cubit/data/model/main/itinerary.dart';
import 'package:mvvm_cubit/view/main/widget/itinerary_container.dart';

class ItineraryList extends StatefulWidget {
  const ItineraryList({
    super.key,
    required this.itineraries,
    required this.onPressed,
  });

  final List<Itinerary> itineraries;
  final VoidCallback onPressed;

  @override
  State<ItineraryList> createState() => _ItineraryList();
}

class _ItineraryList extends State<ItineraryList> {
  List<Itinerary> _itineraries = [];
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
      child: _buildPanel(),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: 0,
      children: _itineraries.map<ExpansionPanelRadio>(
        (Itinerary item) {
          return ExpansionPanelRadio(
            value: item.id,
            headerBuilder: (context, isExpanded) => ListTile(
              title: Text(
                item.title,
                style: headLine2,
              ),
            ),
            body: ItineraryContainer(
              itinerary: item,
              onPressed: _onPressed,
            ),
          );
        },
      ).toList(),
    );
  }
}
