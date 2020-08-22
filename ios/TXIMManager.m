//
//  TXIMManager.m
//  TencentIm
//
//  Created by Choi Wing Chiu on 22/8/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "TXIMManager.h"

@interface TXIMManager() <V2TIMSDKListener>

@end

@implementation TXIMManager {
    BOOL isInit;
    
    int sdkAppId;
    
    NSString *currentReceiver;
    
    NSData *deviceToken;
    
    NSDictionary *configDict;
}

+ (instancetype)getInstance {
    __strong static TXIMManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (BOOL)initWithAppId:(NSString* )appId {
    if (isInit) {
      return YES;
    }
    V2TIMSDKConfig *config = [[V2TIMSDKConfig alloc] init];
    config.logLevel = V2TIM_LOG_NONE;
    
    [[V2TIMManager sharedInstance] setConversationListener:nil];
    return [[V2TIMManager sharedInstance] initSDK:[appId intValue] config:config listener:self];
}

- (void)setConversationListener:(id <V2TIMConversationListener>)listener {
    if (isInit) {
        [[V2TIMManager sharedInstance] setConversationListener:listener];
    }
}

- (void)onConnecting {
    NSLog(@"TIM: onConnecting");
}
- (void)onConnectSuccess {
    NSLog(@"TIM: onConnectSuccess");
}
- (void)onConnectFailed:(int)code err:(NSString*)err {
    NSLog(@"TIM: onConnectFailed");
}

@end
