FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 環境変数を設定
ENV LAMBDA_TASK_ROOT=/var/task

# 必要なパッケージをインストール
RUN set -ex \
    && apt-get update \
    && apt-get install -y curl ffmpeg gzip python3.8 python3-pip unzip xz-utils \
    && apt-get clean \
    && pip3 install awslambdaric

# VoiceVox Core と依存関係のインストール
RUN set -ex \
    && mkdir -p /opt/voicevox && cd /opt/voicevox \
    && curl -L -O https://github.com/VOICEVOX/voicevox_core/releases/download/0.14.3/voicevox_core-linux-x64-cpu-0.14.3.zip \
    && unzip voicevox_core-linux-x64-cpu-0.14.3.zip && rm -f voicevox_core-linux-x64-cpu-0.14.3.zip \
    && curl -L -o open_jtalk_dic_utf_8-1.11.tar.gz \
        https://sourceforge.net/projects/open-jtalk/files/Dictionary/open_jtalk_dic-1.11/open_jtalk_dic_utf_8-1.11.tar.gz/download \
    && tar xzf open_jtalk_dic_utf_8-1.11.tar.gz && rm -f open_jtalk_dic_utf_8-1.11.tar.gz \
    && curl -L -O https://github.com/VOICEVOX/voicevox_core/releases/download/0.14.3/voicevox_core-0.14.3+cpu-cp38-abi3-linux_x86_64.whl \
    && pip3 install voicevox_core-0.14.3+cpu-cp38-abi3-linux_x86_64.whl \
    && rm -f voicevox_core-0.14.3+cpu-cp38-abi3-linux_x86_64.whl

# 環境変数を設定
ENV LD_LIBRARY_PATH=/opt/voicevox/voicevox_core-linux-x64-cpu-0.14.3
ENV OPEN_JTALK_DICT_DIR=/opt/voicevox/open_jtalk_dic_utf_8-1.11

# Python の依存関係をインストール
COPY requirements.txt ./
RUN pip3 install -r requirements.txt

# Lambda 関数のコードをコピー
COPY app.py /var/task/app.py

# エントリーポイントとコマンドを設定
ENTRYPOINT ["/usr/bin/python3.8", "-m", "awslambdaric"]
CMD ["app.lambda_handler"]
