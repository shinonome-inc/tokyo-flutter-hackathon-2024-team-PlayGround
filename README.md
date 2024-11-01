# tokyo-flutter-hackathon-2024

東京 Flutter ハッカソン 2024

## Backend

### 使用技術

AWS CDK 2.151.0

### 仮想環境構築

```
python3 -m venv .venv
source .venv/bin/activate
```

### パッケージのインストール

```
pip install -r requqirements.txt
```

### デプロイ

```
cdk synth
cdk deploy
```

## Mobile

### 使用技術

Flutter 3.24.3
Dart 3.5.3

### 依存関係の更新

```
fvm flutter pub get
```

### Dart ファイルの自動生成

```
fvm dart run build_runner build --delete-conflicting-outputs
```

### VOICEBOX の導入

1. [VOICEVOX](https://voicevox.hiroshiba.jp/)を開発 PC にインストール
2. VOICEVOX の GUI を起動
3. http://localhost:50021/にアクセスできれば OK

現在は localhost で VOICEBOX による音声読み上げを行なっています。

## 使用したアセット

### 音声読み上げ

VOICEVOX:ずんだもん
