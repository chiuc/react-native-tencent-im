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

+ (TXIMMessageInfo *)buildMessage:(TXIMMessageType)type content:(NSString *)content option:(NSDictionary *)option;

+ (TXIMMessageInfo *)buildTextMessage:(NSString *)content;

+ (TXIMMessageInfo *)buildMessageWithTIMMessage:(V2TIMMessage *)msg;

@end

NS_ASSUME_NONNULL_END
