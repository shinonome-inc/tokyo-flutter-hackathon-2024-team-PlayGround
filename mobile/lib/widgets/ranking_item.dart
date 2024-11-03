import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/gradients.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/models/ranking_user.dart';
import 'package:mobile/widgets/circle_icon_image.dart';

class RankingItem extends StatelessWidget {
  const RankingItem({
    super.key,
    required this.rank,
    required this.user,
    required this.dashImagePath,
  });

  final int rank;
  final RankingUser user;
  final String dashImagePath;

  Gradient? get _gradient {
    switch (rank) {
      case 1:
        return Gradients.gold;
      case 2:
        return Gradients.silver;
      case 3:
        return Gradients.bronze;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12.r),
        ),
        gradient: _gradient,
        color: _gradient == null ? AppColors.menuItemBackground : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24.w,
            child: Text(
              rank.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 40.w,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  left: 0,
                  child: Image.asset(
                    dashImagePath,
                    width: 32.w,
                    height: 32.w,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleIconImage(
                    imageUrl: user.avatarUrl,
                    diameter: 20.w,
                    errorImagePath: ImagePaths.defaultUser,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            user.userName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            'Lv. ${user.characterLevel}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
