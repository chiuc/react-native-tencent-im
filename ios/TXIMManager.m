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
    
    NSString *businessID;
    
    NSString *currentReceiver;
    
    NSData *deviceToken;
    
    NSDictionary *configDict;
}

#pragma mark - public method

+ (instancetype)getInstance {
    __strong static TXIMManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (void)configDeviceToken:(NSData *)token {
    deviceToken = token;
}

- (void)configBusinessID:(NSString *)token {
    businessID = token;
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

- (void)setSimpleMessageListener:(id <V2TIMSimpleMsgListener>)listener {
    if (isInit) {
        [[V2TIMManager sharedInstance] addSimpleMsgListener:listener];
    }
}

- (void)setAdvancedMsgListener:(id<V2TIMAdvancedMsgListener>)listener {
    if (isInit) {
        [[V2TIMManager sharedInstance] addAdvancedMsgListener:listener];
    }
}

- (void)setSignalingListener:(id<V2TIMSignalingListener>)listener{
    if (isInit) {
        [[V2TIMManager sharedInstance] addSignalingListener:listener];
    }
}

- (void)loginWithIdentify:(NSString *)identify
                userSig:(NSString *)userSig
                   succ:(V2TIMSucc)succ
                     fail:(V2TIMFail)fail {
    void (^login)(void) = ^(void) {
        [[V2TIMManager sharedInstance] login:identify userSig:userSig succ:^{
            [self configAppAPNSDeviceToken];
            succ();
        } fail:^(int code, NSString *desc) {
            fail(code, desc);
        }];
    };
    
    if ([[V2TIMManager sharedInstance] getLoginStatus] == V2TIM_STATUS_LOGINED) {
        if ([[[V2TIMManager sharedInstance] getLoginUser] isEqualToString:identify]) {
            login();
        } else {
            [[V2TIMManager sharedInstance] logout:^{
                login();
            } fail:^(int code, NSString *desc) {
                fail(code, desc);
            }];
        }
    } else {
        login();
    }
}

- (void)logoutWithSucc:(V2TIMSucc)succ fail:(V2TIMFail)fail {
    if ([[V2TIMManager sharedInstance] getLoginStatus] == V2TIM_STATUS_LOGOUT) {
        succ();
    } else {
        [[V2TIMManager sharedInstance] logout:succ fail:fail];
    }
}

- (void)getConversationList:(V2TIMConversationResultSucc)succ fail:(V2TIMFail)fail {
    if ([[V2TIMManager sharedInstance] getLoginStatus] == V2TIM_STATUS_LOGINED) {
        [[V2TIMManager sharedInstance] getConversationList:0 count:50 succ:^(NSArray<V2TIMConversation *> *list, uint64_t nextSeq, BOOL isFinished) {
            succ(list,nextSeq,isFinished);
        } fail:^(int code, NSString *desc) {
            fail(code, desc);
        }];
    }
}

#pragma mark - private method

- (void)configAppAPNSDeviceToken {
    V2TIMAPNSConfig *confg = [[V2TIMAPNSConfig alloc] init];
    confg.businessID = [businessID intValue];
    confg.token = deviceToken;
    [[V2TIMManager sharedInstance] setAPNS:confg succ:^{
        NSLog(@"[TXIMManager] configAppAPNSDeviceToken #success");
    } fail:^(int code, NSString *desc) {
        NSLog(@"[TXIMManager] configAppAPNSDeviceToken #fail reason:%@", desc);
    }];
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
