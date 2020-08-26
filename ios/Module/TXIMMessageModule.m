//
//  TXIMMessageModule.m
//  react-native-tencent-im
//
//  Created by Choi Wing Chiu on 22/8/2020.
//

#import "TXIMMessageModule.h"
#import "TXIMManager.h"
#import "TXIMEventNameConstant.h"

@implementation TXIMMessageModule

#pragma mark - RCTEventEmitter

- (NSArray<NSString *> *)supportedEvents {
    return @[EventNameOnNewMessage];
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

RCT_EXPORT_MODULE(TXIMMessageModule);

RCT_REMAP_METHOD(getConversationList,
                resolver:(RCTPromiseResolveBlock)resolve
                rejecter:(RCTPromiseRejectBlock)reject) {
    TXIMManager *manager = [TXIMManager getInstance];
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
