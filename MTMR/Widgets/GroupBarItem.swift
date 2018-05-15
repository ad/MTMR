//
//  GroupBarItem.swift
//  MTMR
//
//  Created by Daniel Apatin on 11.05.2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//
import Cocoa

fileprivate extension NSTouchBarItem.Identifier {
    static let test = NSTouchBarItem.Identifier("com.ad.test")
}

class GroupBarItem: NSPopoverTouchBarItem, NSTouchBarDelegate {
    
    var touchBar: NSTouchBar!
    
    var presentingItem: NSPopoverTouchBarItem?
    
    init(identifier: NSTouchBarItem.Identifier, title: String, onLongTap: @escaping () -> ()) {
        super.init(identifier: identifier)
        self.collapsedRepresentationLabel = title
        self.popoverTouchBar = makeTouchBar()
        self.popoverTouchBar.delegate = self
        self.showsCloseButton = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc override func showPopover(_ sender: Any?) {
        print("showPopover")
        if let oldBar = TouchBarController.shared.touchBar {
            NSTouchBar.minimizeSystemModalFunctionBar(oldBar)
        }
        self.touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.test]

        if TouchBarController.shared.controlStripState {
            NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: .controlStripItem)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(touchBar, placement: 1, systemTrayItemIdentifier: .controlStripItem)
        }
    }
    
    func makeTouchBar() -> NSTouchBar {
        let mainBar = NSTouchBar()
        mainBar.delegate = self
        mainBar.defaultItemIdentifiers = [.test]
        print(mainBar.itemIdentifiers)
        return mainBar
    }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        print(identifier)

        if identifier == .test {
            let item = AppScrubberTouchBarItem(identifier: identifier)
            return item
        } else {
            return nil
        }
    }
}
