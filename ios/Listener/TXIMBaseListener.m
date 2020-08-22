//
//  TXIMBaseListener.m
//  TencentIm
//
//  Created by Choi Wing Chiu on 22/8/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "TXIMBaseListener.h"

@interface TXIMBaseListener ()

@property(nonatomic, weak, readwrite) RCTEventEmitter *module;

@end

@implementation TXIMBaseListener

- (instancetype)initWithModule:(RCTEventEmitter *_Nonnull)module eventName:(NSString *_Nullable)eventName {
    self = [super init];
    if (self) {
        _module = module;
        _eventName = eventName;
    }
    return self;
}

- (void)sendEventWithCode:(int)code msg:(NSString *)msg {
    if (_eventName) {
        [_module sendEvent:_eventName code:code msg:msg];
    }
}
@end
