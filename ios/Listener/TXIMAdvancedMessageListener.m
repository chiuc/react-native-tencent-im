//
//  TXIMAdvancedMessageListener.m
//  react-native-tencent-im
//
//  Created by Choi Wing Chiu on 26/8/2020.
//

#import "TXIMAdvancedMessageListener.h"
#import "TXIMManager.h"
#import "TXIMMessageBuilder.h"

@implementation TXIMAdvancedMessageListener

- (void)onRecvNewMessage:(V2TIMMessage *)msg {
    RCTLog(@"[TXIMAdvancedMessageListener] onRecvNewMessage msgID: %@", msg.msgID);
    TXIMMessageInfo *info = [TXIMMessageBuilder buildMessageWithTIMMessage:msg];
    [self.module sendEvent:self.eventName body:[info toDict]];
}

/// 收到消息已读回执（仅单聊有效）
- (void)onRecvC2CReadReceipt:(NSArray<V2TIMMessageReceipt *> *)receiptList{
    RCTLog(@"[TXIMAdvancedMessageListener] onRecvC2CReadReceipt");
}

/// 收到消息撤回
- (void)onRecvMessageRevoked:(NSString *)msgID{
    RCTLog(@"[TXIMAdvancedMessageListener] onRecvMessageRevoked msgID: %@", msgID);
}

@end
