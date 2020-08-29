//
//  TXIMMessageBuilder.h
//  react-native-tencent-im
//
//  Created by Choi Wing Chiu on 22/8/2020.
//

#import <ImSDK/ImSDK.h>
#import "TXIMMessageInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXIMMessageBuilder : NSObject

+ (TXIMMessageInfo *)buildTextMessage:(NSString *)content;

+ (TXIMMessageInfo *)buildCustomFaceMessage:(NSString *)groupId faceName:(NSString *)faceName;

+ (TXIMMessageInfo *)buildImageMessage:(NSString *)url compressed:(Boolean *)compressed appPohto:(Boolean *)appPohto;

+ (TXIMMessageInfo *)buildMessage:(TXIMMessageType)type content:(NSString *)content option:(NSDictionary *)option;

+ (TXIMMessageInfo *)buildMessageWithTIMMessage:(V2TIMMessage *)msg;

+ (NSArray<TXIMMessageInfo *>*) normalizeConversationList:(NSArray<V2TIMConversation*> *)timMessages;

+ (NSArray<TXIMMessageInfo *>*) TIMMessages2MessageInfos:(NSArray<V2TIMConversation*> *)timMessages isGroup:(Boolean *)isGroup;

//+ (TXIMMessageInfo *) TIMMessage2MessageInfo:(V2TIMMessage *)msg isGroup:(Boolean *)isGroup;


@end

NS_ASSUME_NONNULL_END
