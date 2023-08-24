import os
import requests
import time
import numpy as np
import soundfile as sf


def uploadResultAudio(audio_opt, resample_sr, url):
    if url == "" or audio_opt.size == 0:
        return "No need to upload."
    print("save2file sr=%s" % resample_sr)

    ok, msg = False, "Unknown"
    try:
        tmpFile = '/tmp/tmp-process-%d.wav' % int(time.time() * 1000)
        sf.write(tmpFile, np.int16(audio_opt), resample_sr)
        with open(tmpFile, 'rb') as f:
            print("start uploadWav")
            data = f.read()
            ok, msg = uploadProcess(url, data)
        os.remove(tmpFile)
    except FileNotFoundError:
        print("File not found.")
    except PermissionError:
        print("You do not have permission to delete this file.")
    except Exception as e:
        print("Unexpected error:", str(e))
    return url if ok else msg


def uploadProcess(target, data):
    response = requests.put(target, data=data)
    print("upload response: %s" % response.status_code)
    if response.status_code == 200:
        return True, "上传成功"
    elif response.status_code == 403:
        return False, "没有权限"
    elif response.status_code == 404:
        return False, "URL 不存在"
    else:
        return False, "上传失败，状态码：%d" % response.status_code
