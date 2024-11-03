import os
import base64
import io
from urllib import parse
from pydub import AudioSegment
from tempfile import NamedTemporaryFile
from voicevox_core import VoicevoxCore, AccelerationMode

SPEAKER_ID = 1

core = VoicevoxCore(
    acceleration_mode=AccelerationMode.AUTO,
    open_jtalk_dict_dir=os.environ["OPEN_JTALK_DICT_DIR"],
)
core.load_model(SPEAKER_ID)


def lambda_handler(event, context):
    print(event)
    body = base64.b64decode(event["body"]).decode("utf-8")
    query = parse.parse_qs(body)
    texts = query.get("text")
    if not texts or len(texts) == 0:
        return {
            "statusCode": 422,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*',  
                'Access-Control-Allow-Headers': 'Content-Type, Authorization',  
                'Access-Control-Allow-Methods': 'OPTIONS,POST'  
            },
            "body": "Text not provided",
        }
    text = texts[0]
    print(f"text: {text}")

    mp3 = wav_to_mp3(get_voice(text))
    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "audio/mp3",
            'Access-Control-Allow-Origin': '*',  
            'Access-Control-Allow-Headers': 'Content-Type, Authorization',  
            'Access-Control-Allow-Methods': 'OPTIONS,POST'  
        },
        "body": base64.b64encode(mp3).decode('utf-8'),
        "isBase64Encoded": True,
    }


def get_voice(text: str) -> bytes:
    audio_query = core.audio_query(text, SPEAKER_ID)
    return core.synthesis(audio_query, SPEAKER_ID)


def wav_to_mp3(wav: bytes) -> bytes:
    with NamedTemporaryFile() as f:
        AudioSegment.from_wav(io.BytesIO(wav)).export(f.name, format="mp3")
        return f.read()
