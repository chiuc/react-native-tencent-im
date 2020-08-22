#import "TXIMInitializeModule.h"

@implementation TXIMInitializeModule

#pragma mark - RCTEventEmitter

- (NSArray<NSString *> *)supportedEvents {
	return @[EventNameInitializeStatus, EventNameUserStatusChange, EventNameOnNewMessage];
}

#pragma mark - RCTBridgeModule