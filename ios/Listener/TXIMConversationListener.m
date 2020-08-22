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

- (void)onNewConversation:(NSArray<V2TIMConversation*> *) conversationList {
    [self updateConversation:conversationList];
}

- (void)onConversationChanged:(NSArray<V2TIMConversation*> *) conversationList {
    [self updateConversation:conversationList];
}

- (void)updateConversation:(NSArray *)convList {
    
}
@end
