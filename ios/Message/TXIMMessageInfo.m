//
//  TXIMMessageInfo.m
//  react-native-tencent-im
//
//  Created by Choi Wing Chiu on 22/8/2020.
//

#import "TXIMMessageInfo.h"

@implementation TXIMMessageInfo

- (instancetype)initWithType:(TXIMMessageType)type {
    self = [super init];
    if (self) {
        _msgType = type;
        _msgId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (NSDictionary *)toDict {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"peer": _receiver,
        @"sender": _sender,
        @"msgId": _msgId,
        @"msgType": @(_msgType),
        @"msgTime": @(_msgTime),
        @"self": @(_isSelf),
        @"read": @(_isRead),
        @"status": @(_status),
        @"imgWidth": @"",
        @"imgHeight": @"",
        @"lat": @"",
        @"lng": @"",
    }];
    
    if (_senderNickName) {
        dict[@"nickName"] = _senderNickName;
    }
    
    if (_senderAvatar) {
        dict[@"senderAvatar"] = _senderAvatar;
    }
    
    if (_extra) {
        dict[@"extra"] = _extra;
    }
    
    if (_desc) {
        dict[@"desc"] = _desc;
    }
    
    return dict;
}


@end
