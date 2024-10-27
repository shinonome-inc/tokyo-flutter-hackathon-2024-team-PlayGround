import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// セキュアストレージにアクセスするためのリポジトリクラス
///
/// アプリケーションでトークンを安全に保存、取得、削除するための
/// メソッドを提供します。`FlutterSecureStorage`を利用しています。
class SecureStorageRepository {
  final FlutterSecureStorage _storage;

  /// コンストラクタ
  ///
  /// [storage] を指定しない場合、デフォルトで `FlutterSecureStorage` を使用します。
  SecureStorageRepository({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  static const _token = 'token';

  /// トークンを書き込みます
  ///
  /// [token] は保存するトークンの文字列です。
  /// 非同期処理で保存が完了します。
  Future<void> writeToken(String? token) async {
    await _storage.write(key: _token, value: token);
    print('アクセストークンを保存しました: $token');
  }

  /// 保存されているトークンを読み込みます
  ///
  /// 保存されているトークンを返します。
  /// トークンが存在しない場合は `null` を返します。
  Future<String?> readToken() async {
    return await _storage.read(key: _token);
  }

  /// 保存されているトークンを削除します
  ///
  /// 非同期処理でトークンの削除が完了します。
  Future<void> deleteToken() async {
    await _storage.delete(key: _token);
  }
}
