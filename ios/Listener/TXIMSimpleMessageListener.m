//
//  TXIMSimpleMessageListener.m
//  react-native-tencent-im
//
//  Created by Choi Wing Chiu on 26/8/2020.
//

#import "TXIMSimpleMessageListener.h"

@implementation TXIMSimpleMessageListener

/// 收到 C2C 文本消息
- (void)onRecvC2CTextMessage:(NSString *)msgID  sender:(V2TIMUserInfo *)info text:(NSString *)text {
     RCTLog(@"[TXIMSimpleMessageListener] onRecvC2CTextMessage msgID: %@", msgID);
}

/// 收到 C2C 自定义（信令）消息
- (void)onRecvC2CCustomMessage:(NSString *)msgID  sender:(V2TIMUserInfo *)info customData:(NSData *)data {
     RCTLog(@"[TXIMSimpleMessageListener] onRecvC2CCustomMessage msgID: %@", msgID);
}

/// 收到群文本消息
- (void)onRecvGroupTextMessage:(NSString *)msgID groupID:(NSString *)groupID sender:(V2TIMGroupMemberInfo *)info text:(NSString *)text {
     RCTLog(@"[TXIMSimpleMessageListener] onRecvGroupTextMessage msgID: %@ groupID: %@", msgID, groupID);
}

/// 收到群自定义（信令）消息
- (void)onRecvGroupCustomMessage:(NSString *)msgID groupID:(NSString *)groupID sender:(V2TIMGroupMemberInfo *)info customData:(NSData *)data {
     RCTLog(@"[TXIMSimpleMessageListener] onRecvGroupCustomMessage msgID: %@  groupID: %@", msgID, groupID);
}

@end
