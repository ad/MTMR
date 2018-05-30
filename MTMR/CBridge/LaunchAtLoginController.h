//
//  LaunchAtLoginController.h
//  MTMR
//
//  Created by Daniel Apatin on 30.05.2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//

@import Foundation;
@import CoreServices;

@interface LaunchAtLoginController : NSObject {}

@property(assign) BOOL launchAtLogin;

- (BOOL) willLaunchAtLogin: (NSURL*) itemURL;
- (void) setLaunchAtLogin: (BOOL) enabled forURL: (NSURL*) itemURL;

@end
