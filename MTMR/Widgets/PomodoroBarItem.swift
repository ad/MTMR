//
//  PomodoroBarItem.swift
//  MTMR
//
//  Created by Daniel Apatin on 10.05.2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//


import Cocoa

class PomodoroBarItem: CustomButtonTouchBarItem {
    private let interval: TimeInterval
    private var timer: DispatchSourceTimer?

    private var timeLeft: Int = 0

    private var timeLeftString: String {
        return String(format: "%.2i:%.2i", timeLeft / 60, timeLeft % 60)
    }
    
    init(identifier: NSTouchBarItem.Identifier, interval: TimeInterval, onLongTap: @escaping () -> ()) {
        self.interval = interval
        super.init(identifier: identifier, title: " 🍅 ", onTap: onLongTap, onLongTap: onLongTap)
        self.tapClosure = { [weak self] in self?.startStopAction() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func startStopAction() {
        timer == nil ? start() : cancel()
    }
    
    private func start() {
        self.isBordered = true
        self.backgroundColor = .systemGreen
        self.button.bezelStyle = .rounded

        timeLeft = Int(interval)
        let queue: DispatchQueue = DispatchQueue(label: "Timer")
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        timer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .never)
        timer?.setEventHandler(handler: self.tick)
        timer?.resume()
        
        playSound()
    }
    
    private func finish() {
        sendNotication()
        reset()
        playSound()
    }
    
    private func cancel() {
        reset()
        playSound()
    }
    
    private func reset() {
        timer?.cancel()
        timer = nil

        self.isBordered = false
        self.backgroundColor = .clear
        self.button.cell?.title = " 🍅 "
        self.button.bezelStyle = .inline
    }
    
    private func tick() {
        timeLeft -= 1
        DispatchQueue.main.async {
            if self.timeLeft >= 0 {
                self.button.cell?.title = self.timeLeftString
            } else {
                self.finish()
            }
        }
    }
    
    private func playSound() {
        NSSound.beep()
    }
    
    private func sendNotication() {
        let notification: NSUserNotification = NSUserNotification()
        notification.title = "Time's up"
        notification.informativeText = "Keep up the good work!"
        NSUserNotificationCenter.default.deliver(notification)
    }
}
