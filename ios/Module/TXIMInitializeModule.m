//
//  TXIMInitializeModule.m
//  TencentIm
//
//  Created by Choi Wing Chiu on 22/8/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "TXIMInitializeModule.h"
#import "TXIMManager.h"
#import "TXIMEventNameConstant.h"

#import "TXIMConversationListener.h"
#import "TXIMSimpleMessageListener.h"
#import "TXIMAdvancedMessageListener.h"

#import "TXIMMessageInfo.h"

@implementation TXIMInitializeModule

#pragma mark - RCTEventEmitter

- (NSArray<NSString *> *)supportedEvents {
    return @[EventNameInitializeStatus, EventNameUserStatusChange, EventNameOnNewMessage, EventNameLoginStatus, EventNameConversationUpdate];
}

- (void)configListener {
    TXIMManager *manager = [TXIMManager getInstance];
}

- (void)startObserving {
    [self setHasListeners:YES];
}

- (void)stopObserving {
    [self setHasListeners:NO];
}

#pragma mark - RCTBridgeModule

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

- (NSDictionary *)constantsToExport {
        
    NSDictionary *eventNameDict = @{
        @"loginStatus": EventNameLoginStatus,
        @"initializeStatus": EventNameInitializeStatus,
        @"userStatus": EventNameUserStatusChange,
        @"onNewMessage": EventNameOnNewMessage,
        @"onConversationRefresh": EventNameConversationUpdate
    };

    NSDictionary *messageTypeDict = @{
        @"Text": @(TXIMMessageTypeText),
        @"Image": @(TXIMMessageTypeImage),
        @"Sound": @(TXIMMessageTypeAudio),
        @"Video": @(TXIMMessageTypeVideo),
        @"File": @(TXIMMessageTypeFile),
        @"Location": @(TXIMMessageTypeLocation),
        @"Face": @(TXIMMessageTypeFace),
        @"Custom": @(TXIMMessageTypeCustom),
    };

    return @{
        @"EventName": eventNameDict,
        @"MessageType": messageTypeDict,
    };
}

RCT_EXPORT_MODULE(TXIMInitializeModule);

RCT_REMAP_METHOD(login,
                 loginWithAccount:(NSString *)account
                 andUserSig:(NSString *)userSig
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    RCTLog(@"[TXIMInitializeModule] login");
    TXIMManager *manager = [TXIMManager getInstance];
    __weak typeof(self) weakSelf = self;
    [manager loginWithIdentify:account userSig:userSig succ:^{
        [weakSelf sendEvent:EventNameLoginStatus body:@{ @"code": @(0), @"username": account}];
        resolve(@{
          @"code": @(0),
          @"msg": @"Login Success",
        });
    } fail:^(int code, NSString *msg) {
        reject([NSString stringWithFormat:@"%d", code], msg, nil);
    }];
}

RCT_REMAP_METHOD(logout,
                 logoutWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    TXIMManager *manager = [TXIMManager getInstance];
    [manager logoutWithSucc:^{
        resolve(@{
          @"code": @(0),
          @"msg": @"Logout Success",
        });
    } fail:^(int code, NSString *desc) {
        reject([NSString stringWithFormat:@"%@", @(code)], desc, nil);
    }];
}
@end
