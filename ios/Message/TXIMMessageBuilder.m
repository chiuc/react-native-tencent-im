//
//  TXIMMessageBuilder.m
//  react-native-tencent-im
//
//  Created by Choi Wing Chiu on 22/8/2020.
//

#import "TXIMMessageBuilder.h"

#define CURRENT_TIMESTAMP [[NSDate date] timeIntervalSince1970] * 1000

@implementation TXIMMessageBuilder

+ (TXIMMessageInfo *)buildMessage:(TXIMMessageType)type content:(NSString *)content option:(NSDictionary *)option {
    switch (type) {
        case TXIMMessageTypeText:
            return [self buildTextMessage: content];
        default:
            return nil;
    }
}

+ (TXIMMessageInfo *)buildTextMessage:(NSString *)content {
    TXIMMessageInfo *info = [[TXIMMessageInfo alloc] initWithType:TXIMMessageTypeText];
    V2TIMMessage *msg = [[V2TIMManager sharedInstance] createTextMessage:content];
    info.msg = msg;
    info.msgTime = CURRENT_TIMESTAMP;
    info.extra = content;
    return info;
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
@end
