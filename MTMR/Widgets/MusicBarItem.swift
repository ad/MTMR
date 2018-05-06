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
    
    init(identifier: NSTouchBarItem.Identifier, interval: TimeInterval, onLongTap: @escaping () -> ()) {
        self.interval = interval
        
        super.init(identifier: identifier, title: "⏳", onTap: onLongTap, onLongTap: onLongTap)
        
        button.bezelColor = .clear
        button.imageScaling = .scaleProportionallyDown
        button.imagePosition = .imageLeading
        button.image?.size = NSSize(width: 24, height: 24)
        
        button.target = self
        button.cell?.action = #selector(playPause)
        button.action = #selector(playPause)

        DispatchQueue.main.async {
            self.updatePlayer()
        }
    }

    @objc func marquee(){
        let str = self.button.title
        if (str.count > 10) {
            let indexFirst = str.index(str.startIndex, offsetBy: 0)
            let indexSecond = str.index(str.startIndex, offsetBy: 1)
            self.button.title = String(str.suffix(from: indexSecond)) + String(str[indexFirst])
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
                    } else if (musicPlayer.className == "ITunesApplication") {
                        let mp = (musicPlayer as iTunesApplication)
                        mp.playpause!()
                    } else if (musicPlayer.className == "VOXApplication") {
                        let mp = (musicPlayer as VoxApplication)
                        mp.playpause!()
                    }
                    break
                }
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
                                    if (!(tab.name?.hasSuffix("на Яндекс.Музыке"))!) {
                                        tempTitle = (tab.name)!
                                        break
                                    }
                                } else if ((tab.URL?.starts(with: "https://vk.com/audios"))! || (tab.URL?.starts(with: "https://vk.com/music"))!) {
                                    tempTitle = (tab.name)!
                                    break
                                } else if (tab.URL?.starts(with: "https://www.youtube.com/watch"))! {
                                    tempTitle = (tab.name)!
                                    break
                                } else {
                                    ident = ""
                                }
                            }
                        }
                    }
                
                    if (tempTitle == self.songTitle) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.interval) { [weak self] in
                            self?.updatePlayer()
                        }
                        return
                    } else {
                        self.songTitle = tempTitle
                    }
                    
                    DispatchQueue.main.async {
                        if ident != "" {
                            if let appPath = NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: ident) {
                                self.button.cell?.image = NSWorkspace.shared.icon(forFile: appPath)
                                self.button.cell?.image?.size = self.buttonSize
                                iconUpdated = true
                            }
                        }

                        if (self.songTitle != "") {
                            self.button.cell?.title = " " + self.songTitle! + "     "
                            titleUpdated = true
                            self.timer?.invalidate()
                            self.timer = nil
                            self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.marquee), userInfo: nil, repeats: true)
                        }
                    }
                    break
                }
            }
        }
 
        DispatchQueue.main.async {
            if !iconUpdated {
                self.button.cell?.image = nil
            }
            
            if !titleUpdated {
                self.button.cell?.title = ""
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.interval) { [weak self] in
            self?.updatePlayer()
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
}
extension SBApplication: SafariApplication {}

@objc public protocol SafariWindow: SBObjectProtocol {
    @objc optional var name: String { get } // The title of the window.
    @objc optional func tabs() -> SBElementArray
}
extension SBObject: SafariWindow {}

@objc public protocol SafariTab: SBObjectProtocol {
    @objc optional var URL: String { get } // The current URL of the tab.
    @objc optional var name: String { get } // The name of the tab.
}
extension SBObject: SafariTab {}
