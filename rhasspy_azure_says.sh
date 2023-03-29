#!/bin/bash

# Shell script to replace TTS in Rhasspy with AZURE's Cloud TTS
# Installation and usage instructions at https://github.com/Nortonko/rhasspy-MSAzure

# Authentication  (see https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/rest-text-to-speech?tabs=streaming#authentication)
apikey="xxxxxxxxxxxxxx"
tokenurl="https://westeurope.api.cognitive.microsoft.com/sts/v1.0/issueToken"

# Voice and language  (see https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/language-support?tabs=tts#tabpanel_1_tts for a complete list)
voice="sk-SK-ViktoriaNeural"
lang="sk-SK"
gender="Female"

# OutputFormat  (see https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/rest-text-to-speech?tabs=nonstreaming#tabpanel_1_nonstreaming)
OutputFormat="riff-8khz-16bit-mono-pcm"

# Region url  (see https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/rest-text-to-speech?tabs=streaming#convert-text-to-speech)
host="https://westeurope.tts.speech.microsoft.com/cognitiveservices/v1"
useragent="myApp/1.0.0"

# Folder to cache the files - this also contains the .txt index file with a list of all generated files
cache="cache"

###### Do not change anything below this

H1="Ocp-Apim-Subscription-Key: $apikey"
H2="Content-type: application/x-www-form-urlencoded"
H3="Content-Length: 0"
token="$(curl -X POST -H "$H1" -H "$H2" -H "$H3" "$tokenurl")"

H4="X-Microsoft-OutputFormat: $OutputFormat"
H5="Content-Type: application/ssml+xml"
H6="User-Agent: $useragent"
H7="Authorization: Bearer $token"

format="wav"

# The text that is passed in
text=$1

# request body for curl
RB="<speak version='1.0' xml:lang='en-US'><voice xml:lang='$lang' xml:gender='$gender'
    name='$voice'>
        $text
</voice></speak>"

# check/create cache if needed
mkdir -pv "$cache"

# Input text and parameters are used to calculate a hash for caching the wav files so only new speech will call azure
md5string="$text""_""$voice""_""$format"
hash="$(echo -n "$md5string" | md5sum | sed 's/ .*$//')"

cachefile="${cache}/cache${hash}.wav"

# do we have a cachefile?
if [ -f "$cachefile" ]
then
    # cachefile found. Sending it to rhasspy
    cat "${cachefile}"
else
    # cachefile not found, running azure
    curl -X POST "$host" -H "$H4" -H "$H5" -H "$H6" -H "$H7" -d "$RB" -o $cachefile
    # update index
    echo "$hash" "$md5string" >> "$cache"/cacheindex.txt
    cat "${cachefile}"
fi
