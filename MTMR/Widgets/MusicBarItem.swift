//
//  MusicBarItem.swift
//  MTMR
//
//  Created by Daniel Apatin on 05.05.2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//

import Cocoa
import ScriptingBridge

class MusicBarItem: CustomButtonTouchBarItem {
    private let interval: TimeInterval
    private var songTitle: String?
    private var timer: Timer?
    let buttonSize = NSSize(width: 21, height: 21)

    let playerBundleIdentifiers = [
        "com.apple.iTunes",
        "com.spotify.client",
        "com.coppertino.Vox",
        "com.google.Chrome",
        "com.apple.Safari"
    ]

    init(identifier: NSTouchBarItem.Identifier, interval: TimeInterval) {
        self.interval = interval

        super.init(identifier: identifier, title: "⏳")
        self.isBordered = false

        self.tapClosure = { [weak self] in self?.playPause() }
        self.longTapClosure = { [weak self] in self?.nextTrack() }

        self.refreshAndSchedule()
    }

    @objc func marquee(){
        let str = self.title
        if (str.count > 10) {
            let indexFirst = str.index(str.startIndex, offsetBy: 0)
            let indexSecond = str.index(str.startIndex, offsetBy: 1)
            self.title = String(str.suffix(from: indexSecond)) + String(str[indexFirst])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func playPause() {
        for ident in playerBundleIdentifiers {
            if let musicPlayer = SBApplication(bundleIdentifier: ident) {
                if (musicPlayer.isRunning) {
                    if (musicPlayer.className == "SpotifyApplication") {
                        let mp = (musicPlayer as SpotifyApplication)
                        mp.playpause!()
                        return
                    } else if (musicPlayer.className == "ITunesApplication") {
                        let mp = (musicPlayer as iTunesApplication)
                        mp.playpause!()
                        return
                    } else if (musicPlayer.className == "VOXApplication") {
                        let mp = (musicPlayer as VoxApplication)
                        mp.playpause!()
                        return
                    } else if (musicPlayer.className == "SafariApplication") {
                        // You must enable the 'Allow JavaScript from Apple Events' option in Safari's Develop menu to use 'do JavaScript'.
                        let safariApplication = musicPlayer as SafariApplication
                        let safariWindows = safariApplication.windows?().compactMap({ $0 as? SafariWindow })
                        for window in safariWindows! {
                            for tab in window.tabs!() {
                                let tab = tab as! SafariTab
                                if (tab.URL?.starts(with: "https://music.yandex.ru"))! {
                                    _ = safariApplication.doJavaScript!("document.getElementsByClassName('player-controls__btn_play')[0].click()", in: tab)
                                    return
                                } else if ((tab.URL?.starts(with: "https://vk.com/audios"))! || (tab.URL?.starts(with: "https://vk.com/music"))!) {
                                    _ = safariApplication.doJavaScript!("document.getElementsByClassName('audio_page_player_play')[0].click()", in: tab)
                                    return
                                } else if (tab.URL?.starts(with: "https://www.youtube.com/watch"))! {
                                    _ = safariApplication.doJavaScript!("document.getElementById('movie_player').click()", in: tab)
                                    return
                                }
                            }
                        }
                    }
                    //                    else if (musicPlayer.className == "GoogleChromeApplication") {
                    //                        let chromeApplication = musicPlayer as GoogleChromeApplication
                    //                        let chromeWindows = chromeApplication.windows?().compactMap({ $0 as? GoogleChromeWindow })
                    //                        for window in chromeWindows! {
                    //                            for tab in window.tabs!() {
                    //                                let tab = tab as! GoogleChromeTab
                    //                                if (tab.URL?.starts(with: "https://music.yandex.ru"))! {
                    //                                    chromeApplication.executeJavaScript!(javascript: "document.getElementsByClassName('player-controls__btn_play')[0].click()")
                    //                                    break
                    //                                } else if ((tab.URL?.starts(with: "https://vk.com/audios"))! || (tab.URL?.starts(with: "https://vk.com/music"))!) {
                    //                                    chromeApplication.executeJavaScript!(javascript: "document.getElementsByClassName('audio_page_player_ctrl')[0].click()")
                    //                                    break
                    //                                } else if (tab.URL?.starts(with: "https://www.youtube.com/watch"))! {
                    //                                    chromeApplication.executeJavaScript!(javascript: "alert(document.title)") // , id: tab
                    //                                    break // document.getElementById('movie_player').click()
                    //                                }
                    //                            }
                    //                        }
                    //                    }
                    break
                }
            }
        }
    }

    @objc func nextTrack() {
        for ident in playerBundleIdentifiers {
            if let musicPlayer = SBApplication(bundleIdentifier: ident) {
                if (musicPlayer.isRunning) {
                    if (musicPlayer.className == "SpotifyApplication") {
                        let mp = (musicPlayer as SpotifyApplication)
                        mp.nextTrack!()
                        updatePlayer()
                        return
                    } else if (musicPlayer.className == "ITunesApplication") {
                        let mp = (musicPlayer as iTunesApplication)
                        mp.nextTrack!()
                        updatePlayer()
                        return
                    } else if (musicPlayer.className == "VOXApplication") {
                        let mp = (musicPlayer as VoxApplication)
                        mp.next!()
                        updatePlayer()
                        return
                    } else if (musicPlayer.className == "SafariApplication") {
                        // You must enable the 'Allow JavaScript from Apple Events' option in Safari's Develop menu to use 'do JavaScript'.
                        let safariApplication = musicPlayer as SafariApplication
                        let safariWindows = safariApplication.windows?().compactMap({ $0 as? SafariWindow })
                        for window in safariWindows! {
                            for tab in window.tabs!() {
                                let tab = tab as! SafariTab
                                if (tab.URL?.starts(with: "https://music.yandex.ru"))! {
                                    _ = safariApplication.doJavaScript!("document.getElementsByClassName('player-controls__btn_next')[0].click()", in: tab)
                                    updatePlayer()
                                    return
                                } else if ((tab.URL?.starts(with: "https://vk.com/audios"))! || (tab.URL?.starts(with: "https://vk.com/music"))!) {
                                    _ = safariApplication.doJavaScript!("document.getElementsByClassName('audio_page_player_next')[0].click()", in: tab)
                                    updatePlayer()
                                    return
                                } else if (tab.URL?.starts(with: "https://www.youtube.com/watch"))! {
                                    _ = safariApplication.doJavaScript!("document.getElementsByClassName('ytp-next-button')[0].click()", in: tab)
                                    updatePlayer()
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func refreshAndSchedule() {
        DispatchQueue.main.async {
            self.updatePlayer()
            DispatchQueue.main.asyncAfter(deadline: .now() + self.interval) { [weak self] in
                self?.refreshAndSchedule()
            }
        }
    }

    func updatePlayer() {
        var iconUpdated = false
        var titleUpdated = false

        for var ident in playerBundleIdentifiers {
            if let musicPlayer = SBApplication(bundleIdentifier: ident) {
                if (musicPlayer.isRunning) {
                    var tempTitle = ""
                    if (musicPlayer.className == "SpotifyApplication") {
                        tempTitle = (musicPlayer as SpotifyApplication).title
                    } else if (musicPlayer.className == "ITunesApplication") {
                        tempTitle = (musicPlayer as iTunesApplication).title
                    } else if (musicPlayer.className == "VOXApplication") {
                        tempTitle = (musicPlayer as VoxApplication).title
                    } else if (musicPlayer.className == "SafariApplication") {
                        let safariApplication = musicPlayer as SafariApplication
                        let safariWindows = safariApplication.windows?().compactMap({ $0 as? SafariWindow })
                        for window in safariWindows! {
                            for tab in window.tabs!() {
                                let tab = tab as! SafariTab
                                if (tab.URL?.starts(with: "https://music.yandex.ru"))! {
                                    //                                    if (!(tab.name?.hasSuffix("на Яндекс.Музыке"))!) {
                                    tempTitle = (tab.name)!
                                    break
                                    //                                    }
                                } else if ((tab.URL?.starts(with: "https://vk.com/audios"))! || (tab.URL?.starts(with: "https://vk.com/music"))!) {
                                    tempTitle = (tab.name)!
                                    break
                                } else if (tab.URL?.starts(with: "https://www.youtube.com/watch"))! {
                                    tempTitle = (tab.name)!
                                    break
                                }
                            }
                        }
                        if tempTitle == "" {
                            ident = ""
                        }
                    } else if (musicPlayer.className == "GoogleChromeApplication") {
                        let chromeApplication = musicPlayer as GoogleChromeApplication
                        let chromeWindows = chromeApplication.windows?().compactMap({ $0 as? GoogleChromeWindow })
                        for window in chromeWindows! {
                            for tab in window.tabs!() {
                                let tab = tab as! GoogleChromeTab
                                if (tab.URL?.starts(with: "https://music.yandex.ru"))! {
                                    if (!(tab.title?.hasSuffix("на Яндекс.Музыке"))!) {
                                        tempTitle = tab.title!
                                        break
                                    }
                                } else if ((tab.URL?.starts(with: "https://vk.com/audios"))! || (tab.URL?.starts(with: "https://vk.com/music"))!) {
                                    tempTitle = tab.title!
                                    break
                                } else if (tab.URL?.starts(with: "https://www.youtube.com/watch"))! {
                                    tempTitle = tab.title!
                                    break
                                }
                            }
                        }
                        if tempTitle == "" {
                            ident = ""
                        }
                    }

                    if (tempTitle == self.songTitle) {
                        return
                    } else {
                        self.songTitle = tempTitle
                    }

                    if let songTitle = self.songTitle?.ifNotEmpty {
                        self.title = " " + songTitle + "     "
                        titleUpdated = true
                        self.timer?.invalidate()
                        self.timer = nil
                        self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.marquee), userInfo: nil, repeats: true)
                    }

                    if let ident = ident.ifNotEmpty,
                        let appPath = NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: ident) {
                        let image = NSWorkspace.shared.icon(forFile: appPath)
                        image.size = self.buttonSize
                        self.image = image
                        iconUpdated = true
                    }
                    break
                }
            }
        }

        DispatchQueue.main.async {
            if !iconUpdated {
                self.image = nil
            }

            if !titleUpdated {
                self.title = ""
            }
        }
    }
}

@objc protocol SpotifyApplication {
    @objc optional var currentTrack: SpotifyTrack {get}
    @objc optional func nextTrack()
    @objc optional func previousTrack()
    @objc optional func playpause()
}
extension SBApplication: SpotifyApplication{}

@objc protocol SpotifyTrack {
    @objc optional var artist: String {get}
    @objc optional var name: String {get}
}
extension SBObject: SpotifyTrack{}

extension SpotifyApplication {
    var title: String {
        guard let t = currentTrack else { return "" }
        return (t.artist ?? "") + " — " + (t.name ?? "")
    }
}


@objc protocol iTunesApplication {
    @objc optional var currentTrack: iTunesTrack {get}
    @objc optional func playpause()
    @objc optional func nextTrack()
    @objc optional func previousTrack()
}
extension SBApplication: iTunesApplication{}

@objc protocol iTunesTrack {
    @objc optional var artist: String {get}
    @objc optional var name: String {get}
}
extension SBObject: iTunesTrack{}

extension iTunesApplication {
    var title: String {
        guard let t = currentTrack else { return "" }
        return (t.artist ?? "") + " — " + (t.name ?? "")
    }
}



@objc protocol VoxApplication {
    @objc optional func playpause()
    @objc optional func next()
    @objc optional func previous()
    @objc optional var track: String {get}
    @objc optional var artist: String {get}
}
extension SBApplication: VoxApplication{}

extension VoxApplication {
    var title: String {
        return (artist ?? "") + " — " + (track ?? "")
    }
}


@objc public protocol SBObjectProtocol: NSObjectProtocol {
    func get() -> Any!
}

@objc public protocol SBApplicationProtocol: SBObjectProtocol {
    func activate()
    var delegate: SBApplicationDelegate! { get set }
}

@objc public protocol SafariApplication: SBApplicationProtocol {
    @objc optional func windows() -> SBElementArray
    @objc optional func doJavaScript(_ x: String!, in in_: Any!) -> Any // Applies a string of JavaScript code to a document.
}
extension SBApplication: SafariApplication {}

@objc public protocol SafariWindow: SBObjectProtocol {
    @objc optional var name: String { get } // The title of the window.
    @objc optional func tabs() -> SBElementArray
    //    @objc optional var document: SafariDocument { get } // The document whose contents are displayed in the window.
    //    @objc optional func setCurrentTab(_ currentTab: SafariTab!) // The current tab.
}
extension SBObject: SafariWindow {}

//@objc public protocol SafariDocument: SBObjectProtocol {
//    @objc optional var name: String { get } // Its name.
//    @objc optional var URL: String { get } // The current URL of the document.
//}
//extension SBObject: SafariDocument {}

@objc public protocol SafariTab: SBObjectProtocol {
    @objc optional var URL: String { get } // The current URL of the tab.
    @objc optional var name: String { get } // The name of the tab.
}
extension SBObject: SafariTab {}



@objc public protocol GoogleChromeApplication: SBApplicationProtocol {
    @objc optional func windows() -> SBElementArray
    @objc optional func executeJavaScript(javascript: String!) -> Any // Applies a string of JavaScript code to a document. //, id: Any!
}
extension SBApplication: GoogleChromeApplication {}

@objc public protocol GoogleChromeWindow: SBObjectProtocol {
    @objc optional var name: String { get } // The title of the window.
    @objc optional func tabs() -> SBElementArray
}
extension SBObject: GoogleChromeWindow {}

@objc public protocol GoogleChromeTab: SBObjectProtocol {
    @objc optional var URL: String { get } // The current URL of the tab.
    @objc optional var title: String { get } // The name of the tab.
}
extension SBObject: GoogleChromeTab {}
