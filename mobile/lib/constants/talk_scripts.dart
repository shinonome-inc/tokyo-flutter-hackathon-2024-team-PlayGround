/// Dashちゃんの音声読み上げで使用する会話スクリプトを定義するクラス。
///
/// 音声読み上げによる読み間違えを防ぎ、自然な発音にするため、漢字や英語の利用はなるべく避けてひらがなを利用する。
class TalkScripts {
  TalkScripts._();

  static const List<String> shortMessages = [
    'おつかれさま',
    'こんにちは',
    'やっほぉー',
    'おなかすいたなー',
    'ねむたいなー',
    'いつもありがとう',
    'たのしいね',
    'フラッターおもしろいね',
    'ダートだいすき',
    'そらをじゆうにとびたいな',
    'ラーメンくいにいこうぜ',
  ];

  static const String eatingMessage = 'いただきます。あむあむ。あむあむ。あむあむ。おいしい！ごちそうさまでした！';

  static const String promptInjectionWordMessage =
      'きんしされていることばがふくまれているよ...。しつもんのないようをかえてみてね。';

  static const String generativeAIExceptionMessage =
      'そのしつもんにはこたえることができないよ...。しつもんのないようをかえてみてね。';

  static const String exceptionMessage =
      'ちょっといんたーねっとのせつぞくがわるいみたい...。もうしわけないけどもういちどしつもんしなおしてもらえるとうれしいな！';
}
