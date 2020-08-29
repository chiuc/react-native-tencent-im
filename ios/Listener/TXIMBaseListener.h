//
//  TXIMBaseListener.h
//  TencentIm
//
//  Created by Choi Wing Chiu on 22/8/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <ImSDK/ImSDK.h>
#import <React/RCTLog.h>
#import "RCTEventEmitter+TXIMBaseModule.h"
#import "TXIMEventNameConstant.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXIMBaseListener : NSObject

@property(nonatomic, weak, readonly) RCTEventEmitter *module;

@property(nonatomic, strong, readonly) NSString *eventName;

- (instancetype)initWithModule:(RCTEventEmitter *_Nonnull)module eventName:(NSString *_Nullable)eventName;

- (void)sendEventWithCode:(int)code msg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
