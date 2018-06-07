
#import <AppKit/AppKit.h>

extern void DFRElementSetControlStripPresenceForIdentifier(NSTouchBarItemIdentifier, BOOL);

extern void DFRSystemModalShowsCloseBoxWhenFrontMost(BOOL);


@interface NSTouchBarItem (PrivateMethods)

+ (void)addSystemTrayItem:(NSTouchBarItem *)item;

+ (void)removeSystemTrayItem:(NSTouchBarItem *)item;

@end


@interface NSTouchBar (PrivateMethods)

+ (void)presentSystemModalTouchBar:(NSTouchBar *)touchBar placement:(long long)placement systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier;

+ (void)presentSystemModalTouchBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier;

+ (void)dismissSystemModalTouchBar:(NSTouchBar *)touchBar;

+ (void)minimizeSystemModalTouchBar:(NSTouchBar *)touchBar;


+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar placement:(long long)placement systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier;

+ (void)presentSystemModalFunctionBar:(NSTouchBar *)touchBar systemTrayItemIdentifier:(NSTouchBarItemIdentifier)identifier;

+ (void)dismissSystemModalFunctionBar:(NSTouchBar *)touchBar;

+ (void)minimizeSystemModalFunctionBar:(NSTouchBar *)touchBar;

@end

