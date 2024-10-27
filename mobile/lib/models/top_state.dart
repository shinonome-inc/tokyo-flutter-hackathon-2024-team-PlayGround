import 'package:freezed_annotation/freezed_annotation.dart';

part 'top_state.freezed.dart';

@freezed
class TopState with _$TopState {
  const factory TopState({
    required bool isLoading,
  }) = _TopState;
}

const initialTopState = TopState(
  isLoading: false,
);
