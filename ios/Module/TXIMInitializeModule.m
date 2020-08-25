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

@implementation TXIMInitializeModule

#pragma mark - RCTEventEmitter

- (NSArray<NSString *> *)supportedEvents {
    return @[EventNameInitializeStatus, EventNameUserStatusChange, EventNameOnNewMessage];
}

- (void)configListener {
    TXIMManager *manager = [TXIMManager getInstance];
    
    [manager setConversationListener:[[TXIMConversationListener alloc] initWithModule:self eventName:EventNameConversationUpdate]];
    
    [manager setSimpleMessageListener:[[TXIMSimpleMessageListener alloc] initWithModule:self eventName:EventNameANY]];
    
    [manager setAdvancedMsgListener:[[TXIMAdvancedMessageListener alloc] initWithModule:self eventName:EventNameANY]];
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
    };

    NSDictionary *messageTypeDict = @{
//        @"Text": @(IMMessageTypeText),
//        @"Image": @(IMMessageTypeImage),
//        @"Sound": @(IMMessageTypeAudio),
//        @"Video": @(IMMessageTypeVideo),
//        @"File": @(IMMessageTypeFile),
//        @"Location": @(IMMessageTypeLocation),
//        @"Face": @(IMMessageTypeCustomFace),
//        @"Custom": @(IMMessageTypeCustom),
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
    TXIMManager *manager = [TXIMManager getInstance];
    [manager loginWithIdentify:account userSig:userSig succ:^{
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
