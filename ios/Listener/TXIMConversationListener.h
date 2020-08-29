//
//  TXIMConversationListener.h
//  react-native-tencent-im
//
//  Created by Choi Wing Chiu on 22/8/2020.
//

#import <ImSDK/ImSDK.h>
#import "TXIMBaseListener.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXIMConversationListener : TXIMBaseListener <V2TIMConversationListener>

@property (strong, nonatomic) NSArray<V2TIMConversation *>* convLists;

@end

NS_ASSUME_NONNULL_END
