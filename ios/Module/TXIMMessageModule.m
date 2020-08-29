//
//  TXIMMessageModule.m
//  react-native-tencent-im
//
//  Created by Choi Wing Chiu on 22/8/2020.
//

#import "TXIMMessageModule.h"
#import "TXIMManager.h"
#import "TXIMEventNameConstant.h"
#import "TXIMMessageBuilder.h"

@implementation TXIMMessageModule

#pragma mark - RCTEventEmitter

- (NSArray<NSString *> *)supportedEvents {
    return @[EventNameOnNewMessage, EventNameConversationUpdate];
}

- (void)startObserving {
    [self setHasListeners:YES];
}

- (void)stopObserving {
    [self setHasListeners:NO];
}


#pragma mark - RCTBridgeModule

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

- (NSDictionary *)constantsToExport {
        
    NSDictionary *eventNameDict = @{
        @"loginStatus": EventNameLoginStatus,
        @"initializeStatus": EventNameInitializeStatus,
        @"userStatus": EventNameUserStatusChange,
        @"onNewMessage": EventNameOnNewMessage,
        @"onConversationRefresh": EventNameConversationUpdate
    };
    
    return @{
        @"EventName": eventNameDict
    };
}

RCT_EXPORT_MODULE(TXIMMessageModule);

RCT_REMAP_METHOD(getConversationList,
    logoutWithResolver:(RCTPromiseResolveBlock)resolve
    rejecter:(RCTPromiseRejectBlock)reject) {
    TXIMManager *manager = [TXIMManager getInstance];
    [manager getConversationList:^(NSArray<V2TIMConversation *> *list, uint64_t nextSeq, BOOL isFinished) {
        resolve(@{
          @"code": @(0),
          @"msg": @"getConversationList Success"
        });
    } fail:^(int code, NSString *desc) {
        reject([NSString stringWithFormat:@"%@", @(code)], desc, nil);
    }];
}

RCT_REMAP_METHOD(getConversation,
               getConversationWithType:(NSInteger)type
               receiver:(NSString *)receiver
               resolver:(RCTPromiseResolveBlock)resolve
               rejecter:(RCTPromiseRejectBlock)reject) {
    TXIMManager *manager = [TXIMManager getInstance];
    
}

RCT_REMAP_METHOD(sendMessage,
                 sendMessage:(int)type
                 content:(NSString *)content
                 option:(NSDictionary *)option
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {
    TXIMManager *manager = [TXIMManager getInstance];
}

RCT_EXPORT_METHOD(destroyConversation) {
    TXIMManager *manager = [TXIMManager getInstance];
}

@end
