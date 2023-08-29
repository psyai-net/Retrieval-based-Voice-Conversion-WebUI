import os
import requests
import time
import numpy as np
import soundfile as sf
from library.general import timer_decorator
import logging

logging.getLogger("numba").setLevel(logging.WARN)

ATTAG = "AudioTool"


def log(msg):
    logging.warning(f"{ATTAG}-{msg}")


@timer_decorator
def uploadResultAudio(audio_opt, resample_sr, url):
    if url == "" or audio_opt.size == 0:
        return "No need to upload."
    log("save2file sr=%s" % resample_sr)

    ok, msg = False, "Unknown"
    try:
        tmpFile = '/tmp/tmp-process-%d.wav' % int(time.time() * 1000)
        sf.write(tmpFile, np.int16(audio_opt), resample_sr)

        with open(tmpFile, 'rb') as f:
            log("start uploadWav")
            data = f.read()
            ok, msg = uploadProcess(url, data)
        os.remove(tmpFile)
    except FileNotFoundError:
        log("File not found.")
    except PermissionError:
        log("You do not have permission to delete this file.")
    except Exception as e:
        log("Unexpected error: %s" % str(e))
    return url if ok else msg


@timer_decorator
def uploadProcess(target, data):
    response = requests.put(target, data=data)
    log("upload response: %s" % response.status_code)
    if response.status_code == 200:
        return True, "上传成功"
    elif response.status_code == 403:
        return False, "没有权限"
    elif response.status_code == 404:
        return False, "URL 不存在"
    else:
        return False, "上传失败，状态码：%d" % response.status_code
