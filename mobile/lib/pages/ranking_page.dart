import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/models/ranking.dart';
import 'package:mobile/widgets/ranking_item.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePaths.backgroundSummer),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          padding:
              EdgeInsets.only(left: 20.w, right: 20.w, top: 32.h, bottom: 20.h),
          width: 280.w,
          height: 531.h,
          decoration: BoxDecoration(
            color: AppColors.menuBackground,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Column(
            children: [
              Text(
                'ランキング',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 28.h),
              Expanded(
                child: Scrollbar(
                  controller: _controller,
                  thumbVisibility: true,
                  trackVisibility: true,
                  thickness: 6.w,
                  radius: Radius.circular(40.r),
                  child: ListView.builder(
                    controller: _controller,
                    padding: EdgeInsets.only(right: 16.w),
                    itemCount: exampleRankings.length,
                    itemBuilder: (context, index) {
                      final rank = index + 1;
                      final ranking = exampleRankings.elementAt(index);
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: RankingItem(
                          rank: rank,
                          ranking: ranking,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text(
                    'ホームへ戻る',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
