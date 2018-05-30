//
//  LaunchAtLoginController.m
//  MTMR
//
//  Created by Daniel Apatin on 30.05.2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//

#import "LaunchAtLoginController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

static NSString *const StartAtLoginKey = @"launchAtLogin";

@interface LaunchAtLoginController ()
@property(assign) LSSharedFileListRef loginItems;
@end

@implementation LaunchAtLoginController
@synthesize loginItems;

#pragma mark Change Observing

void sharedFileListDidChange(LSSharedFileListRef inList, void *context)
{
    LaunchAtLoginController *self = (__bridge id) context;
    [self willChangeValueForKey:StartAtLoginKey];
    [self didChangeValueForKey:StartAtLoginKey];
}

#pragma mark Initialization

- (id) init
{
    self = [super init];
    loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    LSSharedFileListAddObserver(loginItems, CFRunLoopGetMain(),
                                (CFStringRef)NSDefaultRunLoopMode, sharedFileListDidChange, (voidPtr)CFBridgingRetain(self));
    return self;
}

- (void) dealloc
{
    LSSharedFileListRemoveObserver(loginItems, CFRunLoopGetMain(),
                                   (CFStringRef)NSDefaultRunLoopMode, sharedFileListDidChange, (__bridge void *)(self));
    CFRelease(loginItems);
}

#pragma mark Launch List Control
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
LSSharedFileListItemRef copyItemWithURLinFileList(NSURL* wantedURL, LSSharedFileListRef fileList) {
    if (wantedURL == NULL || fileList == NULL)
        return NULL;
    
    NSArray *listSnapshot = (__bridge_transfer NSArray *)LSSharedFileListCopySnapshot(fileList, NULL);
    for(NSUInteger i = 0; i< [listSnapshot count]; i++) {
        LSSharedFileListItemRef item = (__bridge LSSharedFileListItemRef)[listSnapshot objectAtIndex:i];
        UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
        CFURLRef currentItemURL = NULL;
        LSSharedFileListItemResolve(item, resolutionFlags, &currentItemURL, NULL);
        if (currentItemURL && [(__bridge_transfer NSURL*)currentItemURL isEqual:wantedURL]) {
            CFRetain(item);
            return item;
        }
    }
    
    return NULL;
}
#pragma clang diagnostic pop

- (BOOL) willLaunchAtLogin: (NSURL*) itemURL
{
    return !!copyItemWithURLinFileList(itemURL, loginItems);
}

- (void) setLaunchAtLogin: (BOOL) enabled forURL: (NSURL*) itemURL
{
    LSSharedFileListItemRef appItem = copyItemWithURLinFileList(itemURL, loginItems);
    if (enabled && !appItem) {
        LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemBeforeFirst,
                                      NULL, NULL, (__bridge CFURLRef)itemURL, NULL, NULL);
    } else if (!enabled && appItem) {
        LSSharedFileListItemRemove(loginItems, appItem);
    }
    if (appItem) {
        CFRelease(appItem);
    }
}

#pragma mark Basic Interface

- (NSURL*) appURL
{
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
}

- (void) setLaunchAtLogin: (BOOL) enabled
{
    [self willChangeValueForKey:StartAtLoginKey];
    [self setLaunchAtLogin:enabled forURL:[self appURL]];
    [self didChangeValueForKey:StartAtLoginKey];
}

- (BOOL) launchAtLogin
{
    return [self willLaunchAtLogin:[self appURL]];
}

@end
#pragma clang diagnostic pop
