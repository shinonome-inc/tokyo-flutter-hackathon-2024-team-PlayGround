import 'package:mobile/constants/image_paths.dart';

/// ランキングの仮モデル
///
/// TODO: API繋ぎ込み時にfreezedを用いてバックエンドの仕様に合わせたモデルに変更する。
class Ranking {
  final String dashImagePath;
  final String userImageUrl;
  final String userName;
  final int level;

  const Ranking({
    required this.dashImagePath,
    required this.userImageUrl,
    required this.userName,
    required this.level,
  });
}

const List<Ranking> exampleRankings = [
  Ranking(
    dashImagePath: ImagePaths.dashSample1,
    userImageUrl: 'https://picsum.photos/200?image=1',
    userName: 'ユーザー1',
    level: 77,
  ),
  Ranking(
    dashImagePath: ImagePaths.dashSample2,
    userImageUrl: 'https://picsum.photos/200?image=2',
    userName: 'ユーザー2',
    level: 76,
  ),
  Ranking(
    dashImagePath: ImagePaths.dashSample3,
    userImageUrl: 'https://picsum.photos/200?image=3',
    userName: 'ユーザー3',
    level: 74,
  ),
  Ranking(
    dashImagePath: ImagePaths.dashSample2,
    userImageUrl: 'https://picsum.photos/200?image=4',
    userName: 'ユーザー4',
    level: 70,
  ),
  Ranking(
    dashImagePath: ImagePaths.dashSample1,
    userImageUrl: 'https://picsum.photos/200?image=5',
    userName: 'ユーザー5',
    level: 69,
  ),
  Ranking(
    dashImagePath: ImagePaths.dashSample1,
    userImageUrl: 'https://picsum.photos/200?image=6',
    userName: 'ユーザー6',
    level: 66,
  ),
  Ranking(
    dashImagePath: ImagePaths.dashSample1,
    userImageUrl: 'https://picsum.photos/200?image=7',
    userName: 'ユーザー7',
    level: 64,
  ),
];
