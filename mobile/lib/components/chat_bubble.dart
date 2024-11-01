import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/constants/image_paths.dart';

/// 吹き出しの先端部分の形状を表すenum。
/// NOTE: 実装時間削減のためにleftとrightの実装は省略する。
enum ChatBubbleTip {
  none,
  bottom,
  left;

  bool get isBottom => this == ChatBubbleTip.bottom;
  bool get isLeft => this == ChatBubbleTip.left;
}

/// チャットの吹き出しを表すWidget。
///
/// [message]表示するメッセージのテキスト。
///
/// [tip]吹き出しの先端部分の形状。デフォルトは`ChatBubbleTip.none`。
///
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.tip = ChatBubbleTip.none,
  });

  final String message;
  final ChatBubbleTip tip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (tip.isLeft)
          Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Image.asset(ImagePaths.chatBubbleTipLeft),
          ),
        Flexible(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  message,
                  maxLines: 4,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (tip.isBottom) Image.asset(ImagePaths.chatBubbleTipBottom),
            ],
          ),
        ),
      ],
    );
  }
}
