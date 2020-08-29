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
        @"imgWidth": @"",
        @"imgHeight": @"",
        @"lat": @"",
        @"lng": @"",
    }];
    
    if (_receiver) {
        dict[@"peer"] = _receiver;
    }
    
    if (_sender) {
        dict[@"sender"] = _sender;
    }
    
    if (_msgId) {
        dict[@"msgId"] = _msgId;
    }
    
    if (_msgType) {
        dict[@"msgType"] = @(_msgType);
    }
    
    if (_msgTime) {
        dict[@"msgTime"] = @(_msgTime);
    }
    
    if (_isSelf) {
        dict[@"self"] = @(_isSelf);
    }
    
    if (_isRead) {
        dict[@"read"] = @(_isRead);
    }
    
    if (_status) {
        dict[@"status"] = @(_status);
    }

    
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
