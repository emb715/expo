// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXUtilities.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXReactNativeUserNotificationCenterProxy.h>

@implementation ABI50_0_0EXReactNativeUserNotificationCenterProxy

ABI50_0_0EX_REGISTER_MODULE();

+ (const NSArray<Protocol *> *)exportedInterfaces
{
  return @[@protocol(ABI50_0_0EXUserNotificationCenterProxyInterface)];
}

- (void)getNotificationSettingsWithCompletionHandler:(void(^)(UNNotificationSettings *settings))completionHandler
{
  [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:completionHandler];
}

- (void)requestAuthorizationWithOptions:(UNAuthorizationOptions)options completionHandler:(void (^)(BOOL granted, NSError *__nullable error))completionHandler
{
  [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:completionHandler];
}

@end
