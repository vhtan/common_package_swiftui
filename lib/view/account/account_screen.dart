import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppAsset.user,
              width: 160,
              height: 160,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Nguyễn An',
              style: headLine1,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "annguyen@gmail.com",
              style: textDefault,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Nhân viên giám sát",
              style: textDefault,
            )
          ],
        ),
      ),
    );
  }
}
