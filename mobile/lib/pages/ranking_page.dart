import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/image_paths.dart';
import 'package:mobile/providers/ranking_notifier.dart';
import 'package:mobile/widgets/ranking_item.dart';

class RankingPage extends ConsumerStatefulWidget {
  const RankingPage({super.key});

  @override
  ConsumerState createState() => _RankingPageState();
}

class _RankingPageState extends ConsumerState<RankingPage> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    Future(() async {
      final notifier = ref.read(rankingNotifierProvider.notifier);
      await notifier.fetchRanking();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rankingNotifierProvider);
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
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Scrollbar(
                        controller: _controller,
                        thumbVisibility: true,
                        trackVisibility: true,
                        thickness: 6.w,
                        radius: Radius.circular(40.r),
                        child: ListView.builder(
                          controller: _controller,
                          padding: EdgeInsets.only(right: 16.w),
                          itemCount: state.ranking?.rankings.length ?? 0,
                          itemBuilder: (context, index) {
                            final rank = index + 1;
                            final user =
                                state.ranking?.rankings.elementAt(index);
                            if (user == null) {
                              return const SizedBox.shrink();
                            }
                            return Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              child: RankingItem(
                                rank: rank,
                                user: user,
                                dashImagePath: ImagePaths.dash,
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
