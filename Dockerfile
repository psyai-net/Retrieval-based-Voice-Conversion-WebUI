FROM ubuntu:22.04

## asign apt source url
RUN #apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C
RUN #echo "deb https://mirrors.163.com/ubuntu jammy main restricted universe multiverse" > /etc/apt/sources.list
RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN  apt-get clean

# Install Python and other dependencies
RUN apt-get update && \
    apt-get install -y python3.10 python3-pip

EXPOSE 7865

WORKDIR /app

COPY . .

# asign pip source url
RUN mkdir -p /root/.pip \
&& echo "[global]\ntrusted-host =  mirrors.aliyun.com\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple" > /root/.pip/pip.conf

#RUN apt install apt-utils
RUN apt-get update && apt-get install -y -qq ffmpeg

RUN pip3 install -r requirements.txt

## optional: download pt from remote
#RUN apt-get install -y aria2
#RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/D40k.pth -d pretrained_v2/ -o D40k.pth
#RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/G40k.pth -d pretrained_v2/ -o G40k.pth
#RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/f0D40k.pth -d pretrained_v2/ -o f0D40k.pth
#RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/f0G40k.pth -d pretrained_v2/ -o f0G40k.pth
#
#RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/uvr5_weights/HP2-人声vocals+非人声instrumentals.pth -d uvr5_weights/ -o HP2-人声vocals+非人声instrumentals.pth
#RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/uvr5_weights/HP5-主旋律人声vocals+其他instrumentals.pth -d uvr5_weights/ -o HP5-主旋律人声vocals+其他instrumentals.pth
#
#RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/hubert_base.pt -o hubert_base.pt
#
#RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/rmvpe.pt -o rmvpe.pt

VOLUME [ "/app/weights", "/app/opt" ]

CMD ["python3", "infer-web.py"]