//
//  InputSourceBarItem.swift
//  MTMR
//
//  Created by Daniel Apatin on 22.04.2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//

import Cocoa

class InputSourceBarItem: CustomButtonTouchBarItem {

    fileprivate var notificationCenter: CFNotificationCenter
    let buttonSize = NSSize(width: 21, height: 21)

    init(identifier: NSTouchBarItem.Identifier, onLongTap: @escaping () -> ()) {
        notificationCenter = CFNotificationCenterGetDistributedCenter();
        super.init(identifier: identifier, title: "", onTap: onLongTap, onLongTap: onLongTap)        
        self.tapClosure = { [weak self] in self?.switchInputSource() }
        
        self.button.frame.size = buttonSize
        self.button.bounds.size = buttonSize
        
        observeIputSourceChangedNotification();
        textInputSourceDidChange()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        CFNotificationCenterRemoveEveryObserver(notificationCenter, UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque()));
    }

    @objc public func textInputSourceDidChange() {
        let currentSource = TISCopyCurrentKeyboardInputSource().takeUnretainedValue()

        var iconImage: NSImage? = nil

        if let imageURL = currentSource.iconImageURL {
            if let image = NSImage(contentsOf: imageURL) {
                iconImage = image
            }
        }

        if iconImage == nil, let iconRef = currentSource.iconRef {
            iconImage = NSImage(iconRef: iconRef)
        }

        if (iconImage != nil) {
            self.button.cell?.image = iconImage
            self.button.cell?.image?.size = buttonSize
            self.title = ""
        } else {
            self.title = currentSource.name
        }
    }

    @objc private func switchInputSource() {
        var inputSources: [TISInputSource] = []

        let currentSource = TISCopyCurrentKeyboardInputSource().takeUnretainedValue()
        let inputSourceNSArray = TISCreateInputSourceList(nil, false).takeRetainedValue() as NSArray
        let elements = inputSourceNSArray as! [TISInputSource]

        inputSources = elements.filter({
            $0.category == TISInputSource.Category.keyboardInputSource && $0.isSelectable
        })

        for item in inputSources {
            if (item.id != currentSource.id) {
                TISSelectInputSource(item)
                break
            }
        }
    }

    @objc public func observeIputSourceChangedNotification(){
        let callback: CFNotificationCallback = { center, observer, name, object, info in
            let mySelf = Unmanaged<InputSourceBarItem>.fromOpaque(observer!).takeUnretainedValue()
            mySelf.textInputSourceDidChange()
        }

        CFNotificationCenterAddObserver(notificationCenter,
                                        UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque()),
                                        callback,
                                        kTISNotifySelectedKeyboardInputSourceChanged,
                                        nil,
                                        .deliverImmediately)
    }
}

extension TISInputSource {
    enum Category {
        static var keyboardInputSource: String {
            return kTISCategoryKeyboardInputSource as String
        }
    }

    private func getProperty(_ key: CFString) -> AnyObject? {
        let cfType = TISGetInputSourceProperty(self, key)
        if (cfType != nil) {
            return Unmanaged<AnyObject>.fromOpaque(cfType!).takeUnretainedValue()
        } else {
            return nil
        }
    }

    var id: String {
        return getProperty(kTISPropertyInputSourceID) as! String
    }

    var name: String {
        return getProperty(kTISPropertyLocalizedName) as! String
    }

    var category: String {
        return getProperty(kTISPropertyInputSourceCategory) as! String
    }

    var isSelectable: Bool {
        return getProperty(kTISPropertyInputSourceIsSelectCapable) as! Bool
    }

    var sourceLanguages: [String] {
        return getProperty(kTISPropertyInputSourceLanguages) as! [String]
    }

    var iconImageURL: URL? {
        return getProperty(kTISPropertyIconImageURL) as! URL?
    }

    var iconRef: IconRef? {
        return OpaquePointer(TISGetInputSourceProperty(self, kTISPropertyIconRef)) as IconRef?
    }
}

