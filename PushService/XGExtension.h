//
//  XGExtension.h
//  XGExtension
//
//  Created by uwei on 28/11/2017.
//  Copyright © 2017 mta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

__IOS_AVAILABLE(10.0)
@interface XGExtension : NSObject

/**
 @brief 信鸽推送Service extension管理对象

 @return 管理对象
 */
+ (nonnull instancetype)defaultManager;

/**
 @brief 信鸽推送处理抵达到终端的消息，即消息回执

 @param request 推送请求
 @param appID 信鸽应用ID
 @param handler 处理消息的回调，回调方法中处理关联的富媒体文件(暂不可用)
 */
- (void)handleNotificationRequest:(nonnull UNNotificationRequest *)request appID:(uint32_t)appID contentHandler:(nullable void(^)( NSArray <UNNotificationAttachment *>* _Nullable attachments,  NSError * _Nullable error))handler;

@end
