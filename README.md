# tokyo-flutter-hackathon-2024-pre
東京Flutterハッカソン2024 技術調査用

## Backend


## Mobile
### 使用技術
Flutter 3.24.3
Dart 3.5.3

### 依存関係の更新
```
fvm flutter pub get
```

### Dartファイルの自動生成
```
fvm dart run build_runner build --delete-conflicting-outputs
```

### VOICEBOXの導入
1. [VOICEVOX](https://voicevox.hiroshiba.jp/)を開発PCにインストール
2. VOICEVOXのGUIを起動
3. http://localhost:50021/にアクセスできればOK

現在はlocalhostでVOICEBOXによる音声読み上げを行なっています。

## 使用したアセット
### 音声読み上げ
VOICEVOX:ずんだもん
