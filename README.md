
<p align="center">
    <img src="Resources/logo.png" width="120">
</p>

# This is Fork of "My TouchBar. My rules"
<p align="center">
    <img src="Resources/TouchBar.png">
</p>

[![GitHub release](https://img.shields.io/github/release/toxblh/MTMR.svg)](https://github.com/ad/MTMR/releases)
[![license](https://img.shields.io/github/license/Toxblh/MTMR.svg)](https://github.com/Toxblh/MTMR/blob/master/LICENSE)
[![minimal system requirements](https://img.shields.io/badge/required-macOS%2010.12.2-blue.svg)]()


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
