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
    private let activity: NSBackgroundActivityScheduler
    
    private var _currentTrack: MusicTrack?
    
    let playerBundleIdentifiers = [
        "com.apple.iTunes",
        "com.spotify.client",
        "com.coppertino.Vox"
    ]
    
    init(identifier: NSTouchBarItem.Identifier, interval: TimeInterval, onLongTap: @escaping () -> ()) {
        activity = NSBackgroundActivityScheduler(identifier: "\(identifier.rawValue).updatecheck")
        activity.interval = interval
        
        super.init(identifier: identifier, title: "⏳", onTap: onLongTap, onLongTap: onLongTap)
        
        button.bezelColor = .clear
        button.imageScaling = .scaleProportionallyDown
        button.imagePosition = .imageLeading
        
        button.target = self
        button.cell?.action = #selector(playPause)
        button.action = #selector(playPause)
        
        activity.repeats = true
        activity.qualityOfService = .utility
        activity.schedule { (completion: NSBackgroundActivityScheduler.CompletionHandler) in
            self.updatePlayer()
            completion(NSBackgroundActivityScheduler.Result.finished)
        }
        updatePlayer()
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

        for ident in playerBundleIdentifiers {
            if let musicPlayer = SBApplication(bundleIdentifier: ident) {
                if (musicPlayer.isRunning) {

                    if (musicPlayer.className == "SpotifyApplication") {
                        let mp = (musicPlayer as SpotifyApplication)
                        self._currentTrack = mp._currentTrack
                    } else if (musicPlayer.className == "ITunesApplication") {
                        let mp = (musicPlayer as iTunesApplication)
                        self._currentTrack = mp._currentTrack
                    } else if (musicPlayer.className == "VOXApplication") {
                        let mp = (musicPlayer as VoxApplication)
                        self._currentTrack = mp._currentTrack
                    }
                    
                    DispatchQueue.main.async {
                        if let appPath = NSWorkspace.shared.absolutePathForApplication(withBundleIdentifier: ident) {
                            self.button.cell?.image = NSWorkspace.shared.icon(forFile: appPath)
                            iconUpdated = true
                        }

                        if ((self._currentTrack) != nil && self._currentTrack?.artist != nil && self._currentTrack?.title != nil) {
                            self.button.cell?.title = " " + (self._currentTrack?.artist!)! + " — " + (self._currentTrack?.title!)!
                            titleUpdated = true
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
    }
}

public struct MusicTrack {
    public var title:   String?
    public var artist: String?
}


@objc protocol SpotifyApplication {
    @objc optional var currentTrack: SpotifyTrack {get}
    @objc optional func nextTrack()
    @objc optional func previousTrack()
    @objc optional func playpause()
}
extension SBApplication: SpotifyApplication{}

@objc protocol SpotifyTrack {
    @objc optional var artist: String? {get}
    @objc optional var name: String? {get}
}
extension SBObject: SpotifyTrack{}

extension SpotifyApplication {
    var _currentTrack: MusicTrack? {
        guard let t = currentTrack else { return nil }
        return MusicTrack(title: t.name ?? nil, artist: t.artist ?? nil)
    }
}


@objc protocol iTunesApplication {
    @objc optional var currentTrack: iTunesTrack {get}
    @objc optional func nextTrack()
    @objc optional func playpause()
    @objc optional func previousTrack()
}
extension SBApplication: iTunesApplication{}


@objc protocol iTunesTrack {
    @objc optional var artist: String? {get}
    @objc optional var name: String? {get}
}
extension SBObject: iTunesTrack{}

extension iTunesApplication {
    var _currentTrack: MusicTrack? {
        guard let t = currentTrack else { return nil }
        return MusicTrack(title: t.name ?? nil, artist: t.artist ?? nil)
    }
}



@objc protocol VoxApplication {
    @objc optional func playpause()
    @objc optional func next()
    @objc optional func previous()
    @objc optional var track: String? {get}
    @objc optional var artist: String? {get}
}
extension SBApplication: VoxApplication{}

extension VoxApplication {
    var _currentTrack: MusicTrack {
        return MusicTrack(title: track ?? nil, artist: artist ?? nil)
    }
}
