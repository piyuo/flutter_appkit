# Make google voice

save google text to speech generate voice to local mp4 file

## use text to speech to generate audio

[https://cloud.google.com/text-to-speech]

en_-_US: en-US-Wavenet-C
zh_TW: cmn-TW-Wavenet-A
zh_TW: cmn-CN-Wavenet-A

save text to speech result to json file

## convert json to mp3

```bash
cat new_order_zh_CN.json | grep 'audioContent' | \
sed 's|audioContent| |' | tr -d '\n ":{},' > tmp.txt && \
base64 tmp.txt --decode > new_order_zh_CN.mp3 && \
rm tmp.txt
```
