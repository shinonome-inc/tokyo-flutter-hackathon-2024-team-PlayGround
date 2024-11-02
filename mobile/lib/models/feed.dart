import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed.freezed.dart';
part 'feed.g.dart';

@freezed
class Feed with _$Feed {
  const factory Feed({
    required int currentExperience,
    required int characterLevel,
    required int feedCount,
  }) = _Feed;
  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        currentExperience: json['currentExperience'],
        characterLevel: json['characterLevel'],
        feedCount: json['feedCount'],
      );
}

const initialFeed = Feed(
  currentExperience: 0,
  characterLevel: 1,
  feedCount: 0,
);

const sampleFeed = Feed(
  currentExperience: 100,
  characterLevel: 2,
  feedCount: 10,
);
