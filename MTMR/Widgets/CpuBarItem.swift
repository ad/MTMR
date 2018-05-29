//
//  CpuBarItem.swift
//  MTMR
//
//  Created by Daniel Apatin on 28.05.2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//

import Foundation
import AppKit

class CpuBarItem: CustomButtonTouchBarItem {
    private let interval: TimeInterval
    fileprivate static let machHost = mach_host_self()
    fileprivate var loadPrevious = host_cpu_load_info()
    var history: [Double] = []
    
    init(identifier: NSTouchBarItem.Identifier, interval: TimeInterval) {
        self.interval = interval
        super.init(identifier: identifier, title: "⏳")
        
        refreshAndSchedule()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshAndSchedule() {
        DispatchQueue.main.async {
            let cpu_info = self.usageCPU()
            self.title = (NSString(format: "%.2f", 100.0-cpu_info.idle) as String) + "%"
            self.history.append(100.0-cpu_info.idle)
            if self.history.count > 60 {
                self.history = Array(self.history.suffix(60))
            }
            self.imagePosition = .imageOverlaps
            self.image = self.drawLineOnImage(size: CGSize(width: 60, height: 30))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.interval) { [weak self] in
                self?.refreshAndSchedule()
            }
        }
    }
    
    fileprivate func hostCPULoadInfo() -> host_cpu_load_info {
        var size     = UInt32(MemoryLayout<host_cpu_load_info_data_t>.size / MemoryLayout<integer_t>.size)
        let hostInfo = host_cpu_load_info_t.allocate(capacity: 1)
        
        let _ = hostInfo.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
            host_statistics(CpuBarItem.machHost, HOST_CPU_LOAD_INFO,
                            $0,
                            &size)
        }
        
        let data = hostInfo.move()
        hostInfo.deallocate()
        
        return data
    }
    
    public func usageCPU() -> (system: Double, user: Double, idle: Double, nice: Double) {
            let load = hostCPULoadInfo()
            
            let userDiff = Double(load.cpu_ticks.0 - loadPrevious.cpu_ticks.0)
            let sysDiff  = Double(load.cpu_ticks.1 - loadPrevious.cpu_ticks.1)
            let idleDiff = Double(load.cpu_ticks.2 - loadPrevious.cpu_ticks.2)
            let niceDiff = Double(load.cpu_ticks.3 - loadPrevious.cpu_ticks.3)
            
            let totalTicks = sysDiff + userDiff + niceDiff + idleDiff
            
            let sys  = sysDiff  / totalTicks * 100.0
            let user = userDiff / totalTicks * 100.0
            let idle = idleDiff / totalTicks * 100.0
            let nice = niceDiff / totalTicks * 100.0
            
            loadPrevious = load

            return (sys, user, idle, nice)
    }
    
    func drawLineOnImage(size: CGSize) -> NSImage {
        
        let size = NSMakeSize(size.width, size.height);
        let im = NSImage.init(size: size)
        
        let rep = NSBitmapImageRep.init(bitmapDataPlanes: nil,
                                        pixelsWide: Int(size.width),
                                        pixelsHigh: Int(size.height),
                                        bitsPerSample: 8,
                                        samplesPerPixel: 4,
                                        hasAlpha: true,
                                        isPlanar: false,
                                        colorSpaceName: .calibratedRGB,
                                        bytesPerRow: 0,
                                        bitsPerPixel: 0)
        
        
        im.addRepresentation(rep!)
        im.lockFocus()
        
        let data = self.history
        var pos = 0.0
        
        for x in data {
            let rect = NSMakeRect(CGFloat(pos), 0, 1, size.height*CGFloat(x)/100)
            let ctx = NSGraphicsContext.current?.cgContext
            ctx!.clear(rect)
            if x > 75 {
                ctx!.setFillColor(NSColor(red: 215/255, green: 75/255, blue: 75/255, alpha: 1.0).cgColor)
            } else if x > 50 {
                ctx!.setFillColor(NSColor(red: 245/255, green: 215/255, blue: 75/255, alpha: 1.0).cgColor)
            } else {
                ctx!.setFillColor(NSColor(red: 145/255, green: 215/255, blue: 75/255, alpha: 1.0).cgColor)
            }
            ctx!.fill(rect)
            
            pos += 1.0
        }
        
        im.unlockFocus()
        
        return im
    }
}
