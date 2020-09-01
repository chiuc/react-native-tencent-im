//
//  TXIMMessageInfo.h
//  react-native-tencent-im
//
//  Created by Choi Wing Chiu on 22/8/2020.
//

#import <ImSDK/ImSDK.h>

typedef NS_ENUM(int, TXIMMessageType) {
    TXIMMessageTypeunknow       = 0,///  未知消息
    TXIMMessageTypeText         = 1,/// 文本类型消息
    TXIMMessageTypeCustom       = 2,/// 自定义消息
    TXIMMessageTypeImage        = 3,/// 图片消息
    TXIMMessageTypeAudio        = 4,/// 语音类型消息
    TXIMMessageTypeVideo        = 5,/// 视频类型消息
    TXIMMessageTypeFile         = 6,/// 文件类型消息
    TXIMMessageTypeLocation     = 7,/// 位置类型消息
    TXIMMessageTypeFace         = 8,/// 表情消息
    TXIMMessageTypeGroupTips    = 9,/// 群 Tips 消息
};

NS_ASSUME_NONNULL_BEGIN

@interface TXIMMessageInfo : NSObject

@property(nonatomic, strong) V2TIMMessage *msg;

@property(nonatomic, strong) NSString *msgId;

@property(nonatomic, assign) TXIMMessageType msgType;

@property(nonatomic, assign) NSInteger msgTime;

@property(nonatomic, assign) BOOL isRead;

@property(nonatomic, assign) NSInteger status;

@property(nonatomic, assign) BOOL isSelf;

@property(nonatomic, strong) NSString *sender;

@property(nonatomic, strong) NSString *senderAvatar;

@property(nonatomic, strong) NSString *senderNickName;

@property(nonatomic, strong) NSString *receiver;

@property(nonatomic, strong) NSString *extra;

@property(nonatomic, strong) NSString *desc;

- (instancetype)initWithType:(TXIMMessageType)type;

- (NSDictionary *)toDict;

@end

NS_ASSUME_NONNULL_END
