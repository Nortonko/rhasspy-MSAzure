# rhasspy-Azure
Simple shell script to use Azure Speech service ([MS's cloud TTS service](https://speech.microsoft.com)) in [Rhasspy](https://github.com/rhasspy/rhasspy)

Based on the [jarvis_says.sh](https://github.com/tschmidty69/homeassistant-config/blob/master/snips/jarvis_says.sh) script from [tschmidty69](https://github.com/tschmidty69)'s Home Assistant config (his was for Snips and used Amazon Polly TTS) with help from this [thread](https://community.rhasspy.org/t/custom-text-to-speech/1187)
 on the Rhasspy forums and also inspired by [rhasspy-IBMWatson](https://github.com/Rayz224/rhasspy-IBMWatson)

 Runs only on Rhasspy **2.5.11** or later

## Preparation
1. Create an account on Azure and register for the Azure free account here: https://azure.microsoft.com/en-us/free/
- Create resource -> Speech
- Choose subscription and resource group
- Use the closest region
- You can change the service name
- Choose pricing tier to Free F0
- Keep the defaults otherwise
> The free plan includes 0.5M characters/month which is plenty for personal home use.
>
2. In your dashboard find your service
3. Note your APIKEY and URL

## Manual Installation
1. Copy the [rhasspy_azure_says.sh](https://github.com/Nortonko/rhasspy-MSAzure/blob/main/rhasspy_azure_says.sh) file inside your rhasspy profile folder (rhasspy/profiles/en/)
2. Update the apikey, url, voice and cache variables
- apikey = Your Azure apikey
- tokenurl = Your endpoint url
- voice, lang, gender = The Azure speech voice to use (see https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/language-support?tabs=tts#tabpanel_1_tts for a complete list) (Example:voice `en-GB-BellaNeural`, lang `en-GB`, gender `Female`)
- OutputFormat = Choose non-streaming PCM audio formats (see https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/rest-text-to-speech?tabs=nonstreaming#tabpanel_1_nonstreaming)
- host = Region url  (see https://learn.microsoft.com/en-us/azure/cognitive-services/speech-service/rest-text-to-speech?tabs=streaming#convert-text-to-speech)
- useragent = The application name. (Example:`myApp/1.0.0`)
- cache = the path to the cache folder:

|Installation| Cache path                                                         |
|------------|--------------------------------------------------------------------|
| Docker     | `/profiles/en/tts/cache/`                                          |
| Non-docker | `/home/${USER}/.config/rhasspy/profiles/en/tts/cache/`             |

3. Make the script executable: `chmod a+x /home/${USER}/.config/rhasspy/profiles/en/rhasspy_azure_says.sh` (you might have to run with sudo)
4. Update the Rhasspy TTS settings to Local Command and set Say Program to:

|Installation| Say program path                                                   |
|------------|--------------------------------------------------------------------|
| Docker     | `/profiles/en/rhasspy_watson_says.sh`                              |
| Non-docker | `/home/${USER}/.config/rhasspy/profiles/en/rhasspy_azure_says.sh` |
