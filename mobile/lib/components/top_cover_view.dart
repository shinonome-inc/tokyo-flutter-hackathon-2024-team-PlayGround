import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/constants/image_paths.dart';

class TopCoverView extends StatelessWidget {
  const TopCoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          ImagePaths.backgroundSummer,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 160.h),
              Image.asset(
                ImagePaths.logo,
                width: 300.w,
              ),
              SizedBox(height: 160.h),
              Image.asset(
                ImagePaths.dashDynamic,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
