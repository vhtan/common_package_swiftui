import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class ImageSOS extends StatelessWidget {
  const ImageSOS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColors.border),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.antiAlias,
        // child: Image.asset(
        //   AppAsset.imTextTruct,
        //   fit: BoxFit.fill,
        // ),
        child: const Center(
          child: Text(
            'Chụp ảnh sự cố',
            style: textDefault,
          ),
        ),
      ),
    );
  }
}
