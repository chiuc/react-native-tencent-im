//
//  TXIMMessageBuilder.m
//  react-native-tencent-im
//
//  Created by Choi Wing Chiu on 22/8/2020.
//

#import "TXIMMessageBuilder.h"

#define CURRENT_TIMESTAMP [[NSDate date] timeIntervalSince1970] * 1000

@implementation TXIMMessageBuilder



+ (TXIMMessageInfo *)buildTextMessage:(NSString *)content {
    TXIMMessageInfo *info = [[TXIMMessageInfo alloc] initWithType:TXIMMessageTypeText];
    V2TIMMessage *msg = [[V2TIMManager sharedInstance] createTextMessage:content];
    info.msg = msg;
    info.msgTime = CURRENT_TIMESTAMP;
    info.extra = content;
    info.isSelf = YES;
    info.sender = [[V2TIMManager sharedInstance] getLoginUser];
    return info;
}

+ (TXIMMessageInfo *)buildCustomFaceMessage:(NSString *)groupId faceName:(NSString *)faceName {
    TXIMMessageInfo *info = [[TXIMMessageInfo alloc] initWithType:TXIMMessageTypeFace];
    V2TIMMessage *msg = [[V2TIMManager sharedInstance] createFaceMessage:[groupId intValue] data:[faceName dataUsingEncoding:NSUTF8StringEncoding]];
    info.msg = msg;
    info.msgTime = CURRENT_TIMESTAMP;
    info.extra = @"[自定义表情]";
    info.isSelf = YES;
    info.sender = [[V2TIMManager sharedInstance] getLoginUser];
    return info;
}

+ (TXIMMessageInfo *)buildImageMessage:(NSString *)uri compressed:(Boolean *)compressed appPohto:(Boolean *)appPohto {
    TXIMMessageInfo *info = [[TXIMMessageInfo alloc] initWithType:TXIMMessageTypeImage];
    V2TIMMessage *msg = [[V2TIMManager sharedInstance] createImageMessage:uri];
    info.msg = msg;
    info.msgTime = CURRENT_TIMESTAMP;
    info.extra = @"[图片]";
    info.isSelf = YES;
    info.sender = [[V2TIMManager sharedInstance] getLoginUser];
    return info;
}


+ (TXIMMessageInfo *)buildMessage:(TXIMMessageType)type content:(NSString *)content option:(NSDictionary *)option {
    switch (type) {
        case TXIMMessageTypeText:
            return [self buildTextMessage: content];
        default:
            return nil;
    }
}

+ (TXIMMessageInfo *)buildMessageWithTIMMessage:(V2TIMMessage *)msg {
    if (!msg || msg.status == V2TIM_MSG_STATUS_HAS_DELETED) {
        return nil;
    }
    TXIMMessageInfo *info = [TXIMMessageInfo new];
    [info setMsgType:[self getMessagetype:msg.elemType]];
    [info setMsg:msg];
    [info setMsgId:[msg msgID]];
    [info setMsgTime:[[msg timestamp] timeIntervalSince1970] * 1000];
    [info setIsSelf:[msg isSelf]];

    if (info.msgType == TXIMMessageTypeText) {
        info.extra = msg.textElem.text;
    }
    
    if (info.isSelf) {
        info.sender = [msg sender];
        info.receiver = [msg userID];
        info.isRead = [msg isPeerRead];
    } else {
        info.sender = [msg sender];
        info.senderAvatar = [msg faceURL];
        info.senderNickName = [msg nickName];
    }
    return info;
}

+ (TXIMMessageType) getMessagetype:(V2TIMElemType)type {
    switch (type) {
        case V2TIM_ELEM_TYPE_NONE:
            return TXIMMessageTypeunknow;
        case V2TIM_ELEM_TYPE_TEXT:
            return TXIMMessageTypeText;
        case V2TIM_ELEM_TYPE_CUSTOM:
            return TXIMMessageTypeCustom;
        case V2TIM_ELEM_TYPE_IMAGE:
            return TXIMMessageTypeImage;
        case V2TIM_ELEM_TYPE_SOUND:
            return TXIMMessageTypeAudio;
        case V2TIM_ELEM_TYPE_VIDEO:
            return TXIMMessageTypeVideo;
        case V2TIM_ELEM_TYPE_FILE:
            return TXIMMessageTypeFile;
        case V2TIM_ELEM_TYPE_LOCATION:
            return TXIMMessageTypeLocation;
        case V2TIM_ELEM_TYPE_FACE:
            return TXIMMessageTypeFace;
        case V2TIM_ELEM_TYPE_GROUP_TIPS:
            return TXIMMessageTypeGroupTips;
        default:
            return TXIMMessageTypeunknow;
    }
}

+ (NSArray<TXIMMessageInfo *>*) normalizeConversationList:(NSArray<V2TIMConversation*> *)timMessages {
    NSMutableArray *messageInfos = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < timMessages.count ; ++ i) {
        NSMutableDictionary *objmap = [[NSMutableDictionary alloc] init];
        V2TIMConversation *conv = timMessages[i];
        int unreadNum = [conv unreadCount];
        V2TIMConversationType type = [conv type];
        V2TIMMessage *msg = [conv lastMessage];
        TXIMMessageInfo *info = [self buildMessageWithTIMMessage:msg];
        NSString *peer = [conv userID] != nil ? [conv userID] : [conv groupID];
        [objmap setValue:[NSString stringWithFormat:@"%d", unreadNum] forKey:@"unread"];
        if (!!msg) {
            [objmap setValue:[info toDict] forKey:@"message"];
        }
        [objmap setValue:peer forKey:@"peer"];
        if (type == V2TIM_C2C) {
            [objmap setValue:@"1" forKey:@"type"];
        } else {
            [objmap setValue:@"2" forKey:@"type"];
        }
        [objmap setValue:[conv showName] forKey:@"name"];
        [messageInfos addObject:objmap];
    }
    return messageInfos;
}

+ (NSArray<TXIMMessageInfo *>*) TIMMessages2MessageInfos:(NSArray<V2TIMConversation*> *) timMessages isGroup:(Boolean *)isGroup {
    NSMutableArray *messageInfos = [[NSMutableArray alloc] init];
    
    return messageInfos;
}

//+ (TXIMMessageInfo *) TIMMessage2MessageInfo:(V2TIMMessage *)msg isGroup:(Boolean *)isGroup {
//    
//}

@end
