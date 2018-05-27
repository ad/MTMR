
<p align="center">
    <img src="Resources/logo.png" width="120">
</p>

# This is Fork of "My TouchBar. My rules"

[![GitHub release](https://img.shields.io/github/release/toxblh/MTMR.svg)](https://github.com/ad/MTMR/releases)
[![license](https://img.shields.io/github/license/Toxblh/MTMR.svg)](https://github.com/Toxblh/MTMR/blob/master/LICENSE) [![Total downloads](https://img.shields.io/github/downloads/Toxblh/MTMR/total.svg)](https://github.com/ad/MTMR/releases/latest) ![minimal system requirements](https://img.shields.io/badge/required-macOS%2010.12.2-blue.svg) ![travis](https://travis-ci.org/Toxblh/MTMR.svg?branch=master)

```
  {
    "type": "staticButton",
    "title": "⇲",
    "action": "appleScript",
    "actionAppleScript": {
      "inline":
        "tell application \"Safari\"\rdo JavaScript \"javascript:var video = document.querySelector('video'); video.webkitSetPresentationMode(video.webkitPresentationMode === 'picture-in-picture' ? 'inline' : 'picture-in-picture');\" in document 1\rend tell"
    },
    "align": "left",
    "width": 40
  },
```
