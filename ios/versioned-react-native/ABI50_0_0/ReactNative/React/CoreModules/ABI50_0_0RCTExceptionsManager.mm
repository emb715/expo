/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTExceptionsManager.h"

#import <ABI50_0_0FBReactNativeSpec/ABI50_0_0FBReactNativeSpec.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>
#import <ABI50_0_0React/ABI50_0_0RCTLog.h>
#import <ABI50_0_0React/ABI50_0_0RCTRedBox.h>
#import <ABI50_0_0React/ABI50_0_0RCTRedBoxSetEnabled.h>
#import <ABI50_0_0React/ABI50_0_0RCTReloadCommand.h>
#import <ABI50_0_0React/ABI50_0_0RCTRootView.h>

#import "ABI50_0_0CoreModulesPlugins.h"

@interface ABI50_0_0RCTExceptionsManager () <ABI50_0_0NativeExceptionsManagerSpec>

@end

@implementation ABI50_0_0RCTExceptionsManager

@synthesize moduleRegistry = _moduleRegistry;

ABI50_0_0RCT_EXPORT_MODULE()

- (instancetype)initWithDelegate:(id<ABI50_0_0RCTExceptionsManagerDelegate>)delegate
{
  if ((self = [self init])) {
    _delegate = delegate;
  }
  return self;
}

- (void)reportSoft:(NSString *)message
              stack:(NSArray<NSDictionary *> *)stack
        exceptionId:(double)exceptionId
    extraDataAsJSON:(nullable NSString *)extraDataAsJSON
{
  if (ABI50_0_0RCTRedBoxGetEnabled()) {
    ABI50_0_0RCTRedBox *redbox = [_moduleRegistry moduleForName:"RedBox"];
    [redbox showErrorMessage:message withStack:stack errorCookie:(int)exceptionId];
  }

  if (_delegate) {
    [_delegate handleSoftJSExceptionWithMessage:message
                                          stack:stack
                                    exceptionId:[NSNumber numberWithDouble:exceptionId]
                                extraDataAsJSON:extraDataAsJSON];
  }
}

- (void)reportFatal:(NSString *)message
              stack:(NSArray<NSDictionary *> *)stack
        exceptionId:(double)exceptionId
    extraDataAsJSON:(nullable NSString *)extraDataAsJSON
{
  if (ABI50_0_0RCTRedBoxGetEnabled()) {
    ABI50_0_0RCTRedBox *redbox = [_moduleRegistry moduleForName:"RedBox"];
    [redbox showErrorMessage:message withStack:stack errorCookie:(int)exceptionId];
  }

  if (_delegate) {
    [_delegate handleFatalJSExceptionWithMessage:message
                                           stack:stack
                                     exceptionId:[NSNumber numberWithDouble:exceptionId]
                                 extraDataAsJSON:extraDataAsJSON];
  }

  static NSUInteger reloadRetries = 0;
  if (!ABI50_0_0RCT_DEBUG && reloadRetries < _maxReloadAttempts) {
    reloadRetries++;
    ABI50_0_0RCTTriggerReloadCommandListeners(@"JS Crash Reload");
  } else if (!ABI50_0_0RCT_DEV) {
    NSString *description = [@"Unhandled JS Exception: " stringByAppendingString:message];
    NSDictionary *errorInfo =
        @{NSLocalizedDescriptionKey : description, ABI50_0_0RCTJSStackTraceKey : stack, ABI50_0_0RCTJSExtraDataKey : extraDataAsJSON};
    ABI50_0_0RCTFatal([NSError errorWithDomain:ABI50_0_0RCTErrorDomain code:0 userInfo:errorInfo]);
  }
}

ABI50_0_0RCT_EXPORT_METHOD(reportSoftException
                  : (NSString *)message stack
                  : (NSArray<NSDictionary *> *)stack exceptionId
                  : (double)exceptionId)
{
  [self reportSoft:message stack:stack exceptionId:exceptionId extraDataAsJSON:nil];
}

ABI50_0_0RCT_EXPORT_METHOD(reportFatalException
                  : (NSString *)message stack
                  : (NSArray<NSDictionary *> *)stack exceptionId
                  : (double)exceptionId)
{
  [self reportFatal:message stack:stack exceptionId:exceptionId extraDataAsJSON:nil];
}

ABI50_0_0RCT_EXPORT_METHOD(updateExceptionMessage
                  : (NSString *)message stack
                  : (NSArray<NSDictionary *> *)stack exceptionId
                  : (double)exceptionId)
{
  if (ABI50_0_0RCTRedBoxGetEnabled()) {
    ABI50_0_0RCTRedBox *redbox = [_moduleRegistry moduleForName:"RedBox"];
    [redbox updateErrorMessage:message withStack:stack errorCookie:(int)exceptionId];
  }

  if (_delegate && [_delegate respondsToSelector:@selector(updateJSExceptionWithMessage:stack:exceptionId:)]) {
    [_delegate updateJSExceptionWithMessage:message stack:stack exceptionId:[NSNumber numberWithDouble:exceptionId]];
  }
}

// Deprecated.  Use reportFatalException directly instead.
ABI50_0_0RCT_EXPORT_METHOD(reportUnhandledException : (NSString *)message stack : (NSArray<NSDictionary *> *)stack)
{
  [self reportFatalException:message stack:stack exceptionId:-1];
}

ABI50_0_0RCT_EXPORT_METHOD(dismissRedbox) {}

ABI50_0_0RCT_EXPORT_METHOD(reportException : (ABI50_0_0JS::NativeExceptionsManager::ExceptionData &)data)
{
  NSString *message = data.message();
  double exceptionId = data.id_();

  // Reserialize data.stack() into an array of untyped dictionaries.
  // TODO: (moti) T53588496 Replace `(NSArray<NSDictionary *> *)stack` in
  // reportFatalException etc with a typed interface.
  NSMutableArray<NSDictionary *> *stackArray = [NSMutableArray<NSDictionary *> new];
  for (auto frame : data.stack()) {
    NSMutableDictionary *frameDict = [NSMutableDictionary new];
    if (frame.column().has_value()) {
      frameDict[@"column"] = @(frame.column().value());
    }
    frameDict[@"file"] = frame.file();
    if (frame.lineNumber().has_value()) {
      frameDict[@"lineNumber"] = @(frame.lineNumber().value());
    }
    frameDict[@"methodName"] = frame.methodName();
    if (frame.collapse().has_value()) {
      frameDict[@"collapse"] = @(frame.collapse().value());
    }
    [stackArray addObject:frameDict];
  }

  NSDictionary *extraData = (NSDictionary *)data.extraData();
  NSString *extraDataAsJSON = ABI50_0_0RCTJSONStringify(extraData, NULL);

  if (data.isFatal()) {
    [self reportFatal:message stack:stackArray exceptionId:exceptionId extraDataAsJSON:extraDataAsJSON];
  } else {
    [self reportSoft:message stack:stackArray exceptionId:exceptionId extraDataAsJSON:extraDataAsJSON];
  }
}

- (void)reportJsException:(nullable NSString *)message
                    stack:(nullable NSArray<NSDictionary *> *)stack
              exceptionId:(double)exceptionId
                  isFatal:(bool)isFatal
{
  if (isFatal) {
    [self reportFatalException:message stack:stack exceptionId:exceptionId];
  } else {
    [self reportSoftException:message stack:stack exceptionId:exceptionId];
  }
}

- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule>)getTurboModule:
    (const ABI50_0_0facebook::ABI50_0_0React::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<ABI50_0_0facebook::ABI50_0_0React::NativeExceptionsManagerSpecJSI>(params);
}

@end

Class ABI50_0_0RCTExceptionsManagerCls(void)
{
  return ABI50_0_0RCTExceptionsManager.class;
}
