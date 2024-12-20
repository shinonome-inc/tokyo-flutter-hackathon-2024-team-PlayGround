import 'package:mobile/constants/dress_up_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_count_notifier.g.dart';

@riverpod
class FeedCountNotifier extends _$FeedCountNotifier {
  @override
  int build() => 0;
  get values => DressUpOptions.values;
  set feedCount(int feedCount) => state = feedCount;
}
