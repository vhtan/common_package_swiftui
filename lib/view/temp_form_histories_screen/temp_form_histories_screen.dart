import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/widget/empty_widget.dart';

class TempFormHistoriesScreen extends StatefulWidget {
  const TempFormHistoriesScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TempFormHistoriesScreenState();
}

class _TempFormHistoriesScreenState extends State<TempFormHistoriesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const EmptyWidget(message: 'message');
  }
}
