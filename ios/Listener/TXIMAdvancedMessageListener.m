//
//  TXIMAdvancedMessageListener.m
//  react-native-tencent-im
//
//  Created by Choi Wing Chiu on 26/8/2020.
//

#import "TXIMAdvancedMessageListener.h"

@implementation TXIMAdvancedMessageListener

- (void)onRecvNewMessage:(V2TIMMessage *)msg {
    
}

/// 收到消息已读回执（仅单聊有效）
- (void)onRecvC2CReadReceipt:(NSArray<V2TIMMessageReceipt *> *)receiptList{
    
}

/// 收到消息撤回
- (void)onRecvMessageRevoked:(NSString *)msgID{
    
}

@end
