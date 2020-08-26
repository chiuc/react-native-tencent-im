//
//  TXIMManager.h
//  TencentIm
//
//  Created by Choi Wing Chiu on 22/8/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXIMManager : NSObject <V2TIMSDKListener>

+ (instancetype)getInstance;

- (BOOL)initWithAppId:(NSString* )appId;

- (void)setConversationListener:(id <V2TIMConversationListener>)listener;

- (void)setSimpleMessageListener:(id <V2TIMSimpleMsgListener>)listener;

- (void)setAdvancedMsgListener:(id<V2TIMAdvancedMsgListener>)listener;

- (void)setSignalingListener:(id<V2TIMSignalingListener>)listener;

- (void)loginWithIdentify:(NSString *)identify
                    userSig:(NSString *)userSig
                       succ:(V2TIMSucc)succ
                       fail:(V2TIMFail)fail;

- (void)logoutWithSucc:(V2TIMSucc)succ fail:(V2TIMFail)fail;

- (void)getConversationList:(V2TIMConversationResultSucc)succ fail:(V2TIMFail)fail;

- (void)configDeviceToken:(NSData *)token;

- (void)configBusinessID:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
