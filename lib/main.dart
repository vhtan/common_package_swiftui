import 'package:mvvm_cubit/view/auth/login_screen.dart';
import 'package:mvvm_cubit/view/container/screen/container_screen.dart';
import 'package:mvvm_cubit/viewmodel/auth/auth_cubit.dart';
import 'package:mvvm_cubit/viewmodel/check_point/check_point_cubit.dart';
import 'package:mvvm_cubit/viewmodel/container/container_cubit.dart';
import 'package:mvvm_cubit/viewmodel/main/main_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_cubit/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_cubit/viewmodel/report_sos/report_sos_cubit.dart';

import 'di.dart';

void main() async {
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainCubit>(create: (context) => getIt<MainCubit>()),
        BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
        BlocProvider<ContainerCubit>(
            create: (context) => getIt<ContainerCubit>()),
        BlocProvider<ReportSOSCubit>(
            create: (context) => getIt<ReportSOSCubit>()),
        BlocProvider<CheckPointCubit>(
            create: (context) => getIt<CheckPointCubit>())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightAppTheme,
        home: const ContainerScreen(),
        // home: ExpansionPanelListRadioExampleApp(),
      ),
    );
  }
}

class ExpansionPanelListRadioExampleApp extends StatelessWidget {
  const ExpansionPanelListRadioExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ExpansionPanelList.radio Sample')),
        body: const ExpansionPanelListRadioExample(),
      ),
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.id,
    required this.expandedValue,
    required this.headerValue,
  });

  int id;
  String expandedValue;
  String headerValue;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      id: index,
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class ExpansionPanelListRadioExample extends StatefulWidget {
  const ExpansionPanelListRadioExample({super.key});

  @override
  State<ExpansionPanelListRadioExample> createState() =>
      _ExpansionPanelListRadioExampleState();
}

class _ExpansionPanelListRadioExampleState
    extends State<ExpansionPanelListRadioExample> {
  final List<Item> _data = generateItems(8);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: 2,
      children: _data.map<ExpansionPanelRadio>((Item item) {
        return ExpansionPanelRadio(
            value: item.id,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(item.headerValue),
              );
            },
            body: ListTile(
                title: Text(item.expandedValue),
                subtitle:
                    const Text('To delete this panel, tap the trash can icon'),
                trailing: const Icon(Icons.delete),
                onTap: () {
                  setState(() {
                    _data
                        .removeWhere((Item currentItem) => item == currentItem);
                  });
                }));
      }).toList(),
    );
  }
}
