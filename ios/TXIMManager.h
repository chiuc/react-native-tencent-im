//
//  TXIMManager.h
//  TencentIm
//
//  Created by Choi Wing Chiu on 22/8/2020.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXIMManager : NSObject <V2TIMSDKListener>

+ (instancetype)getInstance;

- (BOOL)initWithAppId:(NSString* )appId;

- (void)setConversationListener:(id <V2TIMConversationListener>)listener;

@end

NS_ASSUME_NONNULL_END
