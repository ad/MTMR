
<p align="center">
    <img src="Resources/logo.png" width="120">
</p>

<<<<<<< HEAD
# This is Fork of "My TouchBar. My rules"
=======
# My TouchBar. My rules

*The TouchBar Customization App for your MacBook Pro*

[![GitHub release](https://img.shields.io/github/release/toxblh/MTMR.svg)](https://github.com/Toxblh/MTMR/releases)
[![license](https://img.shields.io/github/license/Toxblh/MTMR.svg)](https://github.com/Toxblh/MTMR/blob/master/LICENSE) [![Total downloads](https://img.shields.io/github/downloads/Toxblh/MTMR/total.svg)](https://github.com/Toxblh/MTMR/releases/latest) ![minimal system requirements](https://img.shields.io/badge/required-macOS%2010.12.2-blue.svg) ![travis](https://travis-ci.org/Toxblh/MTMR.svg?branch=master)

>>>>>>> 2023ab29f3b1fa1b2290368120f87db7f7ebd562
<p align="center">
    <img src="Resources/TouchBar.png">
</p>

<<<<<<< HEAD
[![GitHub release](https://img.shields.io/github/release/toxblh/MTMR.svg)](https://github.com/ad/MTMR/releases)
[![license](https://img.shields.io/github/license/Toxblh/MTMR.svg)](https://github.com/Toxblh/MTMR/blob/master/LICENSE)
[![minimal system requirements](https://img.shields.io/badge/required-macOS%2010.12.2-blue.svg)]()
=======
**MTMR** Community:
[<img height="24px" src="https://github.com/discourse/DiscourseMobile/raw/master/icon.png" /> Discourse](https://forum.mtmr.app)
[<img height="24px" src="https://telegram.org/img/t_logo.png" /> Telegram](https://t.me/joinchat/AmVYGg8vW38c13_3MxdE_g)

<a href="https://www.buymeacoffee.com/toxblh" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" height="32px" ></a>
<a href="https://www.patreon.com/bePatron?u=9900748"><img height="32px"  src="https://c5.patreon.com/external/logo/become_a_patron_button.png" srcset="https://c5.patreon.com/external/logo/become_a_patron_button@2x.png 2x"></a>
[<img src="https://d1qb2nb5cznatu.cloudfront.net/startups/i/854859-e299e139ab7f79855c0bc589f10b0ec6-medium_jpg.jpg?buster=1453074480" height="32px" /> Become a backer](https://opencollective.com/MTMR#backer)
[<img src="https://d1qb2nb5cznatu.cloudfront.net/startups/i/854859-e299e139ab7f79855c0bc589f10b0ec6-medium_jpg.jpg?buster=1453074480" height="32px" /> Become a sponsor](https://opencollective.com/MTMR#sponsor)


My the idea is to create the program like a platform for plugins for customization TouchBar. I very like BTT and a full custom TouchBar (my [BTT preset](https://github.com/Toxblh/btt-touchbar-preset)). And I want to create it. And it's my the first Swift project for MacOS :)

### Roadmap
- [x] Create the first prototype with TouchBar in Storyboard
- [x] Put in stripe menu on startup the application
- [x] Find how to simulate real buttons like brightness, volume, night shift and etc.
- [x] Time in touchbar!
- [x] First the weather plugin
- [x] Find how to open full-screen TouchBar without the cross and stripe menu
- [x] Find how to add haptic feedback
- [x] Add icon and menu in StatusBar
- [x] Hide from Dock
- [x] Status menu: "preferences", "quit"
- [x] JSON or another approch for save preset, maybe in `~/Library/Application Support/MTMR/`
- [x] Custom buttons size, actions by click
- [x] Layout: [always left, NSSliderView for center, always right]
- [x] System for autoupdate (https://sparkle-project.org/)
- [ ] Overwrite default values from item types (e.g. title for brightness)
- [ ] Custom settings for paddings and margins for buttons
- [ ] XPC Service for scripts
- [ ] UI for settings
- [ ] Import config from BTT

Settings:
- [ ] Interface for plugins and export like presets
- [x] Startup at login
- [ ] Show on/off in Dock
- [ ] Show on/off in StatusBar
- [ ] On/off Haptic Feedback

Maybe:
- [ ] Refactoring the application on packages (AppleScript, JavaScript? and Swift?)


## Installation
- Download last [release](https://github.com/Toxblh/MTMR/releases)
- Or via Homebrew `brew cask install mtmr`

## Preset

File for customize your preset for MTMR: `open ~/Library/Application\ Support/MTMR/items.json`

## Built-in button types:

- escape
- exitTouchbar
- brightnessUp
- brightnessDown
- illuminationUp (keyboard illumination)
- illuminationDown (keyboard illumination)
- volumeDown
- volumeUp
- mute
- dock (half-long click to open app, full-long click to kill app)
- nightShift
- dnd (Dont disturb)
>>>>>>> 2023ab29f3b1fa1b2290368120f87db7f7ebd562


- Added Pomodoro widget
- Added CPU and Memory widgets
- Added Notification (popup) about low battery (notifyPercent option in battery widget config, 10 by default)
- Added more flexible customization of actions

```
        "tapAction": {
            "type": "openUrl",
            "url": "https://yandex.ru/pogoda/",
        },
        "longTapAction": {
            "type": "openUrl",
            "url": "https://openweathermap.org",
        },
```

<<<<<<< HEAD
=======
## Native plugins
- `weather`
> Provider: https://openweathermap.org Need allowance location service
```js
  "type": "weather",
  "refreshInterval": 600,
  "units": "metric", // or imperial
  "icon_type": "text" // or images
  "api_key": "" // you can get the key on openweather
```

- `currency`
> Provider: https://coinbase.com
```js
  "type": "currency",
  "refreshInterval": 600,
  "align": "right",
  "from": "BTC",
  "to": "USD",
```

- `music`
```js
{
  "type": "music",
  "align": "center",
  "width": 80,
  "bordered": false,
  "refreshInterval": 2,
},
```

## Actions:
- `hidKey`
> https://github.com/aosm/IOHIDFamily/blob/master/IOHIDSystem/IOKit/hidsystem/ev_keymap.h use only numbers
```json
 "action": "hidKey",
 "keycode": 53,
```

- `keyPress`
```json
 "action": "keyPress",
 "keycode": 1,
```

- `appleScript`
```js
 "action": "appleScript",
 "actionAppleScript": {
     "inline": "tell application \"Finder\"\rmake new Finder window\rset target of front window to path to home folder as string\ractivate\rend tell"
    // "filePath" or "base64" will work as well
 },
```

- `shellScript`
```js
 "action": "shellScript",
 "executablePath": "/usr/bin/pmset",
 "shellArguments": ["sleepnow"], // optional

```

- `openUrl`
```js
 "action": "openUrl",
 "url": "https://google.com",
```

## LongActions
This then you want to use longPress for some operations is will the same values like for Actions but different additional parameters, example:
```js
 "longAction": "hidKey",
 "longKeycode": 53,
```

- longAction
- longKeycode
- longActionAppleScript
- longExecutablePath
- longShellArguments
- longUrl

## Additional parameters:

- `width` allow to restrict how much room a particular button will take
```json
  "width": 34
```
>>>>>>> 2023ab29f3b1fa1b2290368120f87db7f7ebd562

# Examples:
```
  {
    "type": "staticButton",
    "title": "⇲", // Picture in Picture button
    "action": "appleScript",
    "actionAppleScript": {
      "inline":
        "tell application \"Safari\"\rdo JavaScript \"javascript:var video = document.querySelector('video'); video.webkitSetPresentationMode(video.webkitPresentationMode === 'picture-in-picture' ? 'inline' : 'picture-in-picture');\" in document 1\rend tell"
    },
    "align": "left",
    "width": 40
  },
```

# My current config

<<<<<<< HEAD
```
[
    {
        "type": "escape",
        "width": 64,
        "align": "left",
    },
    {
        "type": "staticButton",
        "title": "⇲",
        "action": "appleScript",
        "actionAppleScript": {
            "inline": "tell application \"Safari\"\rdo JavaScript \"javascript:var video = document.querySelector('video'); video.webkitSetPresentationMode(video.webkitPresentationMode === 'picture-in-picture' ? 'inline' : 'picture-in-picture');\" in document 1\rend tell"
        },
        "align": "left",
            "width": 40
        },
    {
        "type": "dock",
        "width": 350,
        "align": "left",
    },
    {
        "type": "music",
        "align": "center",
        "width": 140,
        "bordered": false,
        "refreshInterval": 30,
    },
    // {
    //     "type": "volume",
    //     "width": 70,
    //     "align": "right",
    //     "image": {
    //         "base64": "iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAMAAADW3miqAAAAVFBMVEUAAAD///////////////////////////////////////////////////////////////////////////////////////////////////////////8wXzyWAAAAG3RSTlMADgXxgBj2hXGzIL2KPOvjx316VEglqMmfmZE4CSbFAAAA00lEQVQ4y9WT6w6CMAyFO9iAAeOmgNr3f0/PAmwYZTPhjx5IuPRL2/VC/6JEUVyi1ZcwUSgSGfNsAkzOgkTDUHHISE4F0ZinoOpDxkJQWR35ArNCCdGEd/NyZivLbJCl4Gv+5GeFlC5BlchrVwlT91ION94gwa2lcmbtYlG9mD3UcAXDiA/loJ4ze3kIga6wdHg4SLKTgx74f7dVSByUvUF6SWrYQRyB4uF84rgDiUdKECqmWosZaMvk2xJvcPf1qMSHLj6+ZxbBr1RnTiynl6Kf1xP6ghxt+GMHnAAAAABJRU5ErkJggg=="
    //     },
    // },
    // {
    //     "type": "brightness",
    //     "width": 70,
    //     "refreshInterval": 1,
    //     "align": "right",
    //     "image": {
    //         "base64": "iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAMAAADW3miqAAAAilBMVEUAAAD////+/v7+/v7////+/v7////+/v7////////+/v7////+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7////+/v7////////+/v7+/v7+/v7+/v7+/v7////////+/v7+/v7+/v7////+/v7////////+/v7+/v7+/v7////+/v7+/v7///9znp3GAAAALXRSTlMAZzr48fAG7oIDUhzqrJnW07iicjcwLA8C5sKxYltFQZSMeE4jDAr6yJ0YFxZ5f33iAAABGklEQVQ4y7XT2Y6CMBiG4Q/KUhbZRUAWl9FZ//u/vQGCKW060TjxPWra5+BvA3iqoDndRwa5jyDrX2gb6NCwW5uSbHNZFixdVl5Ge+lKllAXYeiAdaZN9hZSEdHGgar4PJzBc38e5V0YMTr/AfyYplj0Na5zYVY5Ed2qTYiUKURWqTc+rUsqLYpJqtOZUjbKQ7aGYRSAoaAQuHbj0XlCKY2xCzgpOcvWMKJT6LpuWiFXDAP6ejxKAulycjE07ZiMjn++pYi9adF3uEYc+gpLmI2nJeNumSyEcW/eUMkn84Gq24fE4uM0T+OaqsmIcsw5mKtCshWVab9Vu8CqQZgr74X6kB4yPSwGLdW4qaZ96A9+OTpTgvv1AZ7qF4exMggryAbkAAAAAElFTkSuQmCC"
    //     },
    // },
    {
        "type": "weather",
        "refreshInterval": 1800,
        "align": "right",
        "units": "metric",
        "width": 55,
        "bordered": false,
        "tapAction": {
            "type": "openUrl",
            "url": "https://yandex.ru/pogoda/",
        },
        "longTapAction": {
            "type": "openUrl",
            "url": "https://openweathermap.org",
        },
    },
    {
        "type": "currency",
        "refreshInterval": 600,
        "align": "right",
        "from": "USD",
        "to": "RUB",
        "width": 55,
        "bordered": false,
        "tapAction": {
            "type": "openUrl",
            "url": "https://www.finam.ru/profile/mosbirzha-valyutnyj-rynok/usdrubtod-usd-rub/tehanalys-light/?freq=3&type=3&autoupdate=1&ma=6&maval=7&uf=1&indval=7&lvl1=9&lv1val=7&lvl2=1&lv2val=&lvl3=1&lv3val=&Apply=%CE%E1%ED%EE%E2%E8%F2%FC",
        },
        "longTapAction": {
            "type": "openUrl",
            "url": "https://news.yandex.ru/quotes/2002.html",
        },
    },
    {
        "type": "battery",
        "align": "right",
        "bordered": false,
        "tapAction": {
            "type": "shellScript",
            "executablePath": "/usr/bin/pmset",
            "shellArguments": ["displaysleepnow"],
        },
    },
    {
        "type": "inputsource",
        "align": "right",
        "bordered": false,
    },
    {
        "type": "pomodoro",
        "align": "right",
        "bordered": false,
        "width": 65,
        "refreshInterval": 30,
    },
    {
        "type": "group",
        "align": "center",
        "bordered": true,
        "title": "stats",
        "items": [
            {
                "type": "close",
                "align": "left",
                "width": 45
            },
            // {
            //     "title": "ip",
            //     "type": "appleScriptTitledButton",
            //     "refreshInterval": 10, //optional
            //     "source": {
            //         "inline": "return \"IP \" & do shell script \"curl http:\/\/ipinfo.io\/ip\""
            //     },
            // },
            {
                "title": "cpu",
                "type": "appleScriptTitledButton",
                "refreshInterval": 10, //optional
                "source": {
                    "inline": "set cpu to do shell script \"ps axo %cpu | awk '{s+=$1}END{print s}'\"\rreturn  \"CPU \" & cpu & \"%\""
                },
                "tapAction": {
                    "type": "appleScript",
                    "appleScript": "activate application \"Activity Monitor\"\rtell application \"System Events\"\r\ttell process \"Activity Monitor\"\r\t\ttell radio button \"CPU\" of radio group 1 of group 2 of toolbar 1 of window 1 to perform action \"AXPress\"\r\tend tell\rend tell",
                },
            },
            {
                "title": "mem",
                "type": "appleScriptTitledButton",
                "refreshInterval": 10, //optional
                "source": {
                    "inline": "set mem to do shell script \"ps -A -o %mem | awk '{s+=$1}END{print s}'\"\rreturn \"MEM \" & mem & \"%\""
                },
                "tapAction": {
                    "type": "appleScript",
                    "appleScript": "activate application \"Activity Monitor\"\rtell application \"System Events\"\r\ttell process \"Activity Monitor\"\r\t\ttell radio button \"Memory\" of radio group 1 of group 2 of toolbar 1 of window 1 to perform action \"AXPress\"\r\tend tell\rend tell",
                },
            },
        ]
    },
    {
        "type": "group",
        "align": "center",
        "bordered": true,
        "title": "media",
        "items": [
            {
                "type": "close",
                "align": "left",
                "width": 45
            },
            {
                "type": "volumeDown",
                "align": "center",
                "width": 30
            },
            {
                "type": "volume",
                "width": 70,
                "align": "center",
                "image": {
                    "base64": "iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAMAAADW3miqAAAAVFBMVEUAAAD///////////////////////////////////////////////////////////////////////////////////////////////////////////8wXzyWAAAAG3RSTlMADgXxgBj2hXGzIL2KPOvjx316VEglqMmfmZE4CSbFAAAA00lEQVQ4y9WT6w6CMAyFO9iAAeOmgNr3f0/PAmwYZTPhjx5IuPRL2/VC/6JEUVyi1ZcwUSgSGfNsAkzOgkTDUHHISE4F0ZinoOpDxkJQWR35ArNCCdGEd/NyZivLbJCl4Gv+5GeFlC5BlchrVwlT91ION94gwa2lcmbtYlG9mD3UcAXDiA/loJ4ze3kIga6wdHg4SLKTgx74f7dVSByUvUF6SWrYQRyB4uF84rgDiUdKECqmWosZaMvk2xJvcPf1qMSHLj6+ZxbBr1RnTiynl6Kf1xP6ghxt+GMHnAAAAABJRU5ErkJggg=="
                },
            },
            {
                "type": "volumeUp",
                "align": "center",
                "width": 30
            },
            {
                "type": "mute",
                "align": "center",
                "width": 30
            },
            {
                "type": "brightnessDown",
                "align": "center",
                "width": 36
            },
            {
                "type": "brightness",
                "width": 70,
                "refreshInterval": 1,
                "align": "center",
                "image": {
                    "base64": "iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAMAAADW3miqAAAAilBMVEUAAAD////+/v7+/v7////+/v7////+/v7////////+/v7////+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7+/v7////+/v7////////+/v7+/v7+/v7+/v7+/v7////////+/v7+/v7+/v7////+/v7////////+/v7+/v7+/v7////+/v7+/v7///9znp3GAAAALXRSTlMAZzr48fAG7oIDUhzqrJnW07iicjcwLA8C5sKxYltFQZSMeE4jDAr6yJ0YFxZ5f33iAAABGklEQVQ4y7XT2Y6CMBiG4Q/KUhbZRUAWl9FZ//u/vQGCKW060TjxPWra5+BvA3iqoDndRwa5jyDrX2gb6NCwW5uSbHNZFixdVl5Ge+lKllAXYeiAdaZN9hZSEdHGgar4PJzBc38e5V0YMTr/AfyYplj0Na5zYVY5Ed2qTYiUKURWqTc+rUsqLYpJqtOZUjbKQ7aGYRSAoaAQuHbj0XlCKY2xCzgpOcvWMKJT6LpuWiFXDAP6ejxKAulycjE07ZiMjn++pYi9adF3uEYc+gpLmI2nJeNumSyEcW/eUMkn84Gq24fE4uM0T+OaqsmIcsw5mKtCshWVab9Vu8CqQZgr74X6kB4yPSwGLdW4qaZ96A9+OTpTgvv1AZ7qF4exMggryAbkAAAAAElFTkSuQmCC"
                },
            },
            {
                "type": "brightnessUp",
                "align": "center",
                "width": 36
            },
            {
                "type": "timeButton",
                "align": "center",
                "bordered": false,
            },
        ]
    },
    {
        "type": "timeButton",
        "align": "right",
        "bordered": false,
    },
]
=======
### Author's presets

[@Toxblh preset](Resources/toxblh.json)

[@ReDetection preset](Resources/ReDetection.json)

### User's presets

[@luongvo209 preset](Resources/luongvo209.json)
![](Resources/luongvo209.png)

## Credits

Built by [@Toxblh](https://patreon.com/toxblh) and [@ReDetection](http://patreon.com/ReDetection).

[![Analytics](https://ga-beacon.appspot.com/UA-96373624-2/mtmr?pixel)](https://github.com/igrigorik/ga-beacon)
>>>>>>> 2023ab29f3b1fa1b2290368120f87db7f7ebd562
