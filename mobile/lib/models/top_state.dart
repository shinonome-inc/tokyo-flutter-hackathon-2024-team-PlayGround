import 'package:freezed_annotation/freezed_annotation.dart';

part 'top_state.freezed.dart';

@freezed
class TopState with _$TopState {
  const factory TopState({
    required bool isLoading,
    required bool showWebView,
  }) = _TopState;
}

const initialTopState = TopState(
  isLoading: false,
  showWebView: false,
);
