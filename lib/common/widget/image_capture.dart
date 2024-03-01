import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_cubit/common/logger/logger.dart';
import 'package:mvvm_cubit/core/app_asset.dart';
import 'package:mvvm_cubit/core/app_extension.dart';
import 'package:mvvm_cubit/core/app_style.dart';

class ImageCapture extends StatelessWidget {
  const ImageCapture({
    super.key,
    required this.title,
    required this.imageFile,
    this.imagePath,
    required this.captureCallback,
    required this.deleteCallback,
  });

  final String title;
  final File? imageFile;
  final String? imagePath;
  final VoidCallback captureCallback;
  final VoidCallback deleteCallback;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          border: (imageFile == null && imagePath == null)
              ? Border.all(width: 1, color: AppColors.border)
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.antiAlias,
        child: (imageFile != null || imagePath != null)
            ? Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  if (imageFile != null && imagePath == null)
                    Image.file(
                      imageFile!,
                      fit: BoxFit.fitWidth,
                    ),
                  if (imageFile == null && imagePath != null)
                    CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      imageUrl: imagePath!,
                      placeholder: (context, url) => AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          AppAsset.placeHolder,
                          fit: BoxFit.fill,
                        ),
                      ),
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
