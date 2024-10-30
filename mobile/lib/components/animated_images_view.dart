import 'dart:async';

import 'package:flutter/material.dart';

/// 複数の画像をコマ送りのアニメーション表示するウィジェット。
///
/// [isStart] アニメーションを開始するかどうか。
/// `true`になったタイミングでアニメーションを開始する。
/// `false`になったタイミングでアニメーションを停止する
/// デフォルトは`false`。
///
/// [imagePathList] 表示したい画像のパスのリスト。
///
/// [intervalMilliseconds] 画像を切り替える間隔のミリ秒数。デフォルトは`500`。
///
/// [delayedMilliseconds] アニメーションを開始するまでの遅延時間のミリ秒数。デフォルトは`0`。
///
/// [isLoop] ループ再生するかどうか。デフォルトは`true`。
///
/// [showOnlyPlaying] アニメーション再生中のみ表示するかどうか。デフォルトは`false`。
class AnimatedImagesView extends StatefulWidget {
  final List<String> imagePathList;
  final int intervalMilliseconds;
  final int delayedMilliseconds;
  final bool isStart;
  final bool isLoop;
  final bool showOnlyPlaying;

  const AnimatedImagesView({
    super.key,
    required this.imagePathList,
    this.intervalMilliseconds = 500,
    this.delayedMilliseconds = 0,
    this.isStart = false,
    this.isLoop = true,
    this.showOnlyPlaying = false,
  });

  @override
  _AnimatedImagesViewState createState() => _AnimatedImagesViewState();
}

class _AnimatedImagesViewState extends State<AnimatedImagesView> {
  bool _isPlaying = false;
  int _currentIndex = 0;
  Timer? _timer;

  void _setPlaying(bool isPlaying) {
    setState(() {
      _isPlaying = isPlaying;
    });
  }

  Future<void> _startAnimation() async {
    if (_timer != null) return;
    _setPlaying(true);
    await Future.delayed(Duration(milliseconds: widget.delayedMilliseconds));
    final intervalDuration =
        Duration(milliseconds: widget.intervalMilliseconds);
    _timer = Timer.periodic(intervalDuration, (timer) {
      setState(() {
        if (_currentIndex < widget.imagePathList.length - 1) {
          _currentIndex++;
        } else if (widget.isLoop) {
          _currentIndex = 0;
        } else {
          _timer?.cancel();
          _timer = null;
          _setPlaying(false);
        }
      });
    });
  }

  void _stopAnimation() {
    _timer?.cancel();
    _timer = null;
    _isPlaying = false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isStart) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(AnimatedImagesView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // isStartの変更を検出し、アニメーションを開始・停止する
    if (widget.isStart && !oldWidget.isStart) {
      _startAnimation();
    } else if (!widget.isStart && oldWidget.isStart) {
      _stopAnimation();
      _setPlaying(true);
    }
  }

  @override
  void dispose() {
    _stopAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hideImage = widget.showOnlyPlaying && !_isPlaying;
    return hideImage
        ? const SizedBox.shrink()
        : Image.asset(widget.imagePathList.elementAt(_currentIndex));
  }
}
