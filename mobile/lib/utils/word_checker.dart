class WordChecker {
  WordChecker._();

  static final WordChecker instance = WordChecker._();

  bool containsBlacklistWords(String text, List<String> blacklistWords) {
    // 入力されたテキストがいずれかのブラックリストワードを含んでいるかを判定
    for (String word in blacklistWords) {
      if (text.contains(word)) {
        return true; // ブラックリストワードが含まれている場合
      }
    }
    return false; // ブラックリストワードが含まれていない場合
  }
}
