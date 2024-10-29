import 'package:audioplayers/audioplayers.dart';
import 'package:mobile/models/home_state.dart';
import 'package:mobile/services/voice_box_client.dart';
import 'package:mobile/utils/file_converter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    return initialHomeState;
  }

  void setShowMenuSubButtons(bool showMenuSubButtons) {
    state = state.copyWith(showMenuSubButtons: showMenuSubButtons);
  }

  void toggleShowMenuSubButtons() {
    setShowMenuSubButtons(!state.showMenuSubButtons);
  }

  Future<void> talkWithDash() async {
    final query = await VoiceBoxClient.instance.createQuery(
      text: 'ぼくの名前はダッシュ。主食はらーめんだよ。',
    );
    final bytes = await VoiceBoxClient.instance.createVoice(query: query);
    final file = await FileConverter.convertBytesToWavFile(bytes);
    final player = AudioPlayer();
    await player.play(DeviceFileSource(file.path));
  }
}
