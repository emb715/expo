// Copyright 2015-present 650 Industries. All rights reserved.

@import UIKit;

#import "ABI50_0_0EXDisabledDevLoadingView.h"
#import "ABI50_0_0EXDevSettings.h"

@implementation ABI50_0_0EXDisabledDevLoadingView {
  BOOL _isObserving;
}

+ (NSString *)moduleName { return @"ABI50_0_0RCTDevLoadingView"; }


ABI50_0_0RCT_EXPORT_METHOD(hide)
{
  ABI50_0_0RCTDevSettings *settings = [[super bridge] devSettings];
  BOOL isFastRefreshEnabled = [settings isHotLoadingEnabled];
  if (_isObserving && isFastRefreshEnabled) {
    [self sendEventWithName:@"devLoadingView:hide" body:@{}];
  }
}

ABI50_0_0RCT_EXPORT_METHOD(showMessage:(NSString *)message color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor)
{
  ABI50_0_0RCTDevSettings *settings = [[super bridge] devSettings];
  BOOL isFastRefreshEnabled = [settings isHotLoadingEnabled];
  if (_isObserving && isFastRefreshEnabled) {
    [self sendEventWithName:@"devLoadingView:showMessage" body:@{@"message":message}];
  }
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"devLoadingView:showMessage", @"devLoadingView:hide"];
}

- (void)startObserving
{
  _isObserving = YES;
}

- (void)stopObserving
{
  _isObserving = NO;
}

// ABI50_0_0RCTDevLoadingViewProtocol implementations

+ (void)setEnabled:(BOOL)enabled
{

}

- (void)showWithURL:(NSURL *)URL
{

}

- (void)updateProgress:(ABI50_0_0RCTLoadingProgress *)progress
{

}

@end

