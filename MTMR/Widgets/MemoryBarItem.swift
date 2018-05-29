//
//  MemoryBarItem.swift
//  MTMR
//
//  Created by Daniel Apatin on 28.05.2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//

import Foundation

class MemoryBarItem: CustomButtonTouchBarItem {
    private let interval: TimeInterval
    fileprivate static let machHost = mach_host_self()
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
            let mem_info = self.memoryUsage()
            let total_mem = Double(self.hostBasicInfo().max_mem) / 1073741824
            
            self.title = (NSString(format: "%.2f", total_mem-(mem_info.active+mem_info.wired+mem_info.compressed)) as String) + "GB"
            
            self.history.append((mem_info.active+mem_info.wired+mem_info.compressed)*100/total_mem)
            
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
    
    func memoryUsage() -> (free: Double, active: Double, inactive: Double, wired: Double, compressed: Double) {
            let stats = self.VMStatistics64()
            
            let free       = Double(stats.free_count) * Double(PAGE_SIZE) / 1073741824
            let active     = Double(stats.active_count) * Double(PAGE_SIZE) / 1073741824
            let inactive   = Double(stats.inactive_count) * Double(PAGE_SIZE) / 1073741824
            let wired      = Double(stats.wire_count) * Double(PAGE_SIZE) / 1073741824
            let compressed = Double(stats.compressor_page_count) * Double(PAGE_SIZE) / 1073741824
            
            return (free, active, inactive, wired, compressed)
    }
    
    func hostBasicInfo() -> host_basic_info {
        var size     = UInt32(MemoryLayout<host_basic_info_data_t>.size / MemoryLayout<integer_t>.size)
        let hostInfo = host_basic_info_t.allocate(capacity: 1)
        
        let _ = hostInfo.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
            host_info(MemoryBarItem.machHost, HOST_BASIC_INFO, $0, &size)
        }
        
        let data = hostInfo.move()
        hostInfo.deallocate()
        
        return data
    }
    
    func VMStatistics64() -> vm_statistics64 {
        var size     =  UInt32(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
        let hostInfo = vm_statistics64_t.allocate(capacity: 1)
        
        let _ = hostInfo.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
            host_statistics64(MemoryBarItem.machHost,
                              HOST_VM_INFO64,
                              $0,
                              &size)
        }
        
        let data = hostInfo.move()
        hostInfo.deallocate()
        
        return data
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
            if x > 90 {
                ctx!.setFillColor(NSColor(red: 215/255, green: 75/255, blue: 75/255, alpha: 1.0).cgColor)
            } else if x > 75 {
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
