import 'package:freezed_annotation/freezed_annotation.dart';

part 'launch_state.freezed.dart';

@freezed
class LaunchState with _$LaunchState {
  const factory LaunchState({
    required bool isLoading,
    required double opacity,
  }) = _LaunchState;
}

const initialLaunchState = LaunchState(
  isLoading: false,
  opacity: 0.0,
);
