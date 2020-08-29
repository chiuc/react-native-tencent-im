//
//  TXIMConversationListener.m
//  react-native-tencent-im
//
//  Created by Choi Wing Chiu on 22/8/2020.
//

#import "TXIMConversationListener.h"
#import "TXIMMessageBuilder.h"
#import "TXIMManager.h"

@implementation TXIMConversationListener

 /**
 * 同步服务器会话开始，SDK 会在登录成功或者断网重连后自动同步服务器会话，您可以监听这个事件做一些 UI 进度展示操作。
 */
- (void)onSyncServerStart {
    RCTLog(@"[TXIMConversationListener] onSyncServerStart");
}

/**
 * 同步服务器会话完成，如果会话有变更，会通过 onNewConversation | onConversationChanged 回调告知客户
 */
- (void)onSyncServerFinish {
    RCTLog(@"[TXIMConversationListener] onSyncServerFinish");
}

/**
 * 同步服务器会话失败
 */
- (void)onSyncServerFailed {
    RCTLog(@"[TXIMConversationListener] onSyncServerFailed");
}

/**
 * 有新的会话（比如收到一个新同事发来的单聊消息、或者被拉入了一个新的群组中），可以根据会话的 lastMessage -> timestamp 重新对会话列表做排序。
 */
- (void)onNewConversation:(NSArray<V2TIMConversation*> *) conversationList {
    RCTLog(@"[TXIMConversationListener] onNewConversation");
    [self updateConversation:conversationList];
}

/**
 * 某些会话的关键信息发生变化（未读计数发生变化、最后一条消息被更新等等），可以根据会话的 lastMessage -> timestamp 重新对会话列表做排序。
 */


- (void)onConversationChanged:(NSArray<V2TIMConversation*> *) conversationList {
    RCTLog(@"[TXIMConversationListener] onConversationChanged");
    [self updateConversation:conversationList];
}


- (void)updateConversation:(NSArray *)convList {
    
}

@end
