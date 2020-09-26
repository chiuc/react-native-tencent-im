//
//  TXIMManager.m
//  TencentIm
//
//  Created by Choi Wing Chiu on 22/8/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "TXIMManager.h"
#import "TXIMMessageInfo.h"
#import "TXIMMessageBuilder.h"
#import <React/RCTLog.h>
#import <ImSDK/ImSDK.h>

@interface TXIMManager() <V2TIMSDKListener>

@end

@implementation TXIMManager {
    BOOL isInit;
    
    int sdkAppId;
    
    NSString *businessID;
    
    V2TIMConversation *conversation;
    
    NSString *currentReceiver;
    
    NSData *deviceToken;
    
    NSDictionary *configDict;
    
    NSMutableArray<V2TIMConversation *> *convLists;
    
    id<V2TIMConversationListener> conversationListener;
    
    id<V2TIMSimpleMsgListener> simpleMessageListener;
    
    id<V2TIMAdvancedMsgListener> advancedMsgListener;
    
    id<V2TIMSignalingListener> signalingListener;
}

#pragma mark - public method

+ (instancetype)getInstance {
    __strong static TXIMManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        convLists = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)configDeviceToken:(NSData *)token {
    deviceToken = token;
    [self configAppAPNSDeviceToken];
}

- (void)configBusinessID:(NSString *)token {
    businessID = token;
}

- (BOOL)initWithAppId:(NSString* )appId {
    if (isInit) {
      return YES;
    }
    
    V2TIMSDKConfig *config = [[V2TIMSDKConfig alloc] init];
    config.logLevel = V2TIM_LOG_NONE;
    
    [[V2TIMManager sharedInstance] setConversationListener:nil];
    
    return [[V2TIMManager sharedInstance] initSDK:[appId intValue] config:config listener:self];
}

- (void)setConversationListener:(id <V2TIMConversationListener>)listener {
    [[V2TIMManager sharedInstance] setConversationListener:listener];
    conversationListener = listener;
}

- (void)setSimpleMessageListener:(id <V2TIMSimpleMsgListener>)listener {
    [[V2TIMManager sharedInstance] addSimpleMsgListener:listener];
    simpleMessageListener = listener;
}

- (void)setAdvancedMsgListener:(id<V2TIMAdvancedMsgListener>)listener {
    [[V2TIMManager sharedInstance] addAdvancedMsgListener:listener];
    advancedMsgListener = listener;
}

- (void)setSignalingListener:(id<V2TIMSignalingListener>)listener{
    [[V2TIMManager sharedInstance] addSignalingListener:listener];
    signalingListener = listener;
}

- (void)loginWithIdentify:(NSString *)identify
                userSig:(NSString *)userSig
                   succ:(V2TIMSucc)succ
                     fail:(V2TIMFail)fail {
    void (^login)(void) = ^(void) {
        [[V2TIMManager sharedInstance] login:identify userSig:userSig succ:^{
            [self configAppAPNSDeviceToken];
            succ();
        } fail:^(int code, NSString *desc) {
            fail(code, desc);
        }];
    };
    
    if ([[V2TIMManager sharedInstance] getLoginStatus] == V2TIM_STATUS_LOGINED) {
        if ([[[V2TIMManager sharedInstance] getLoginUser] isEqualToString:identify]) {
            login();
        } else {
            [[V2TIMManager sharedInstance] logout:^{
                login();
            } fail:^(int code, NSString *desc) {
                fail(code, desc);
            }];
        }
    } else {
        login();
    }
}

- (void)logoutWithSucc:(V2TIMSucc)succ fail:(V2TIMFail)fail {
    if ([[V2TIMManager sharedInstance] getLoginStatus] == V2TIM_STATUS_LOGOUT) {
        succ();
    } else {
        [[V2TIMManager sharedInstance] logout:succ fail:fail];
    }
}

- (void)getConversationWithType:(NSInteger)type
                       receiver:(NSString *)receiver
                           succ:(V2TIMMessageListSucc)succ
                           fail:(V2TIMFail)fail {
    if ([[V2TIMManager sharedInstance] getLoginStatus] == V2TIM_STATUS_LOGINED) {
        currentReceiver = receiver;
        if (type == 1) {
            [[V2TIMManager sharedInstance] getC2CHistoryMessageList:receiver count:100 lastMsg:nil succ:^(NSArray<V2TIMMessage *> *msgs) {
                succ(msgs);
            } fail:^(int code, NSString *desc) {
                fail(code, desc);
            }];
        } else {
            [[V2TIMManager sharedInstance] getGroupHistoryMessageList:receiver count:100 lastMsg:nil succ:^(NSArray<V2TIMMessage *> *msgs) {
                succ(msgs);
            } fail:^(int code, NSString *desc) {
                fail(code, desc);
            }];
        }
    } else {
        fail(-1, @"Please login");
    }
}

- (void)setMessageRead:(V2TIMMessage *)message
                  succ:(V2TIMSucc)succ
                  fail:(V2TIMFail)fail {
    if ([[message userID] isEqualToString:[conversation userID]]) {
        [[V2TIMManager sharedInstance] markC2CMessageAsRead:[conversation userID] succ:^{
            succ();
        } fail:^(int code, NSString *desc) {
            fail(code, desc);
        }];
    }
}

- (void)sendMessage:(int)type
            content:(NSString *)content
            isGroup:(BOOL)isGroup
               succ:(TXIMSendMsgSucc)succ
               fail:(TIMFail)fail {
    if ([[V2TIMManager sharedInstance] getLoginStatus] != V2TIM_STATUS_LOGINED) {
        fail(-1, @"Please login");
        return;
    }
    
    TXIMMessageInfo *msg = [TXIMMessageBuilder buildMessage:type content:content option:nil];
    msg.sender = [[V2TIMManager sharedInstance] getLoginUser];
    msg.receiver = currentReceiver;
    msg.isSelf = YES;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:currentReceiver forKey:@"target"];
    
    V2TIMOfflinePushInfo *info = [[V2TIMOfflinePushInfo alloc] init];
    info.ext = [self convertToJsonData:dict];
    
    [[V2TIMManager sharedInstance] sendMessage:msg.msg
                                     receiver:!isGroup?currentReceiver: nil
                                      groupID:isGroup?currentReceiver: nil
                                      priority:V2TIM_PRIORITY_DEFAULT
                                onlineUserOnly:false
                               offlinePushInfo:info
                                      progress:^(uint32_t progress) {
        
    } succ:^{
        succ(msg);
    } fail:^(int code, NSString *desc) {
        fail(code, desc);
    }];
}

- (void)destroyConversationWithSucc:(V2TIMSucc)succ
                               fail:(V2TIMFail)fail {
    if (conversation) {
        [[V2TIMManager sharedInstance] deleteConversation:[conversation conversationID] succ:^{
            self->conversation = nil;
            self->currentReceiver = nil;
            succ();
        } fail:^(int code, NSString *desc) {
            fail(code, desc);
        }];
    }
}

- (int)getUnReadCount {
    return 0;
}

- (void)getConversationList:(V2TIMConversationResultSucc)succ fail:(V2TIMFail)fail {
    if ([[V2TIMManager sharedInstance] getLoginStatus] == V2TIM_STATUS_LOGINED) {
        [[V2TIMManager sharedInstance] getConversationList:0 count:50 succ:^(NSArray<V2TIMConversation *> *list, uint64_t nextSeq, BOOL isFinished) {
            [self updateConversationWithList:list];
            succ(list,nextSeq,isFinished);
        } fail:^(int code, NSString *desc) {
            fail(code, desc);
        }];
    }
}

#pragma mark - private method

- (void)configAppAPNSDeviceToken {
    if (deviceToken != nil && [[V2TIMManager sharedInstance] getLoginStatus] == V2TIM_STATUS_LOGINED) {
        V2TIMAPNSConfig *confg = [[V2TIMAPNSConfig alloc] init];
        confg.businessID = [businessID intValue];
        confg.token = deviceToken;
        [[V2TIMManager sharedInstance] setAPNS:confg succ:^{
            RCTLog(@"[TXIMManager] configAppAPNSDeviceToken #success");
        } fail:^(int code, NSString *desc) {
            RCTLog(@"[TXIMManager] configAppAPNSDeviceToken #fail reason:%@", desc);
        }];
    }
}

- (void)onConnecting {
    RCTLog(@"[TXIMManager] onConnecting");
}

- (void)onConnectSuccess {
    RCTLog(@"[TXIMManager] onConnectSuccess");
}

- (void)onConnectFailed:(int)code err:(NSString*)err {
    RCTLog(@"[TXIMManager] onConnectFailed");
}

- (void)updateConversationWithList:(NSArray *)convList {
    for (int i = 0 ; i < convList.count ; ++ i) {
        V2TIMConversation *conv = convList[i];
        BOOL isExit = NO;
        for (int j = 0; j < convLists.count; ++ j) {
            V2TIMConversation *_Conv = convLists[j];
            if ([[self getConversationIDFromConversation:_Conv] isEqualToString:[self getConversationIDFromConversation:conv]]) {
                [convLists replaceObjectAtIndex:j withObject:conv];
                isExit = YES;
                break;
            }
        }
        if (!isExit) {
            [convLists addObject:conv];
        }
    }
    
    [convLists sortUsingComparator:^NSComparisonResult(V2TIMConversation *obj1, V2TIMConversation *obj2) {
        return [obj2.lastMessage.timestamp compare:obj1.lastMessage.timestamp];
    }];
}

- (void)updateConversationWithMessage:(V2TIMMessage *)message {
    for (int j = 0; j < convLists.count; ++ j) {
        V2TIMConversation *_Conv = convLists[j];
        if ([[self getConversationIDFromConversation:_Conv] isEqualToString:[self getConversationIDFromMessage:message]]) {
            break;
        }
    }
}

- (NSString*) getConversationIDFromMessage:(V2TIMMessage *)message {
    return message.groupID ? message.groupID : message.userID;
}

- (NSString*) getConversationIDFromConversation:(V2TIMConversation *)conv {
    return conv.groupID ? conv.groupID : conv.userID;
}

- (NSMutableArray*) getConversation {
    return convLists;
}

- (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;

    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}
@end
