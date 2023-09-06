import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class ImageCapture extends StatelessWidget {
  const ImageCapture({
    Key? key,
    required this.title,
    required this.imageFile,
    required this.captureCallback,
    required this.deleteCallback,
  }) : super(key: key);
  final String title;
  final File? imageFile;
  final VoidCallback captureCallback;
  final VoidCallback deleteCallback;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          border: imageFile == null
              ? Border.all(width: 1, color: AppColors.border)
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.antiAlias,
        // child: Image.asset(
        //   AppAsset.imTextTruct,
        //   fit: BoxFit.fill,
        // ),
        child: imageFile != null
            ? Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  Image.file(
                    imageFile!,
                    fit: BoxFit.fitWidth,
                  ),
                  IconButton(
                    onPressed: deleteCallback,
                    icon: const Icon(
                      Icons.delete,
                      size: 40,
                    ),
                  )
                ],
              )
            : GestureDetector(
                onTap: captureCallback,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                    ),
                    Text(
                      title,
                      style: textDefault,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
