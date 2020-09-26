//
//  TXIMManager.h
//  TencentIm
//
//  Created by Choi Wing Chiu on 22/8/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>
#import <React/RCTLog.h>

@class TXIMMessageInfo;

typedef void (^TXIMSendMsgSucc)(TXIMMessageInfo *_Nonnull msg);

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

- (void)setMessageRead:(V2TIMMessage *)message
                  succ:(V2TIMSucc)succ
                  fail:(V2TIMFail)fail;

- (void)sendMessage:(int)type
            content:(NSString *)content
            isGroup:(BOOL)isGroup
               succ:(TXIMSendMsgSucc)succ
               fail:(TIMFail)fail;

- (void)destroyConversationWithSucc:(V2TIMSucc)succ
                               fail:(V2TIMFail)fail;

- (void)getConversationList:(V2TIMConversationResultSucc)succ fail:(V2TIMFail)fail;

- (void)getConversationWithType:(NSInteger)type
                       receiver:(NSString *)receiver
                           succ:(V2TIMMessageListSucc)succ
                           fail:(V2TIMFail)fail;

- (int)getUnReadCount;

- (void)configDeviceToken:(NSData *)token;

- (void)configBusinessID:(NSString *)token;

- (void)updateConversationWithList:(NSArray *)convList;

- (void)updateConversationWithMessage:(V2TIMMessage *)message;

- (NSMutableArray*) getConversation;

@end

NS_ASSUME_NONNULL_END
