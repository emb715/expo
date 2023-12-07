/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTFrameUpdate.h>
#import <ABI50_0_0React/ABI50_0_0RCTInitializing.h>
#import <ABI50_0_0React/ABI50_0_0RCTInvalidating.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ABI50_0_0RCTTimingDelegate

- (void)callTimers:(NSArray<NSNumber *> *)timers;
- (void)immediatelyCallTimer:(NSNumber *)callbackID;
- (void)callIdleCallbacks:(NSNumber *)absoluteFrameStartMS;

@end

@interface ABI50_0_0RCTTiming : NSObject <ABI50_0_0RCTBridgeModule, ABI50_0_0RCTInvalidating, ABI50_0_0RCTFrameUpdateObserver, ABI50_0_0RCTInitializing>

- (instancetype)initWithDelegate:(id<ABI50_0_0RCTTimingDelegate>)delegate;
- (void)createTimerForNextFrame:(NSNumber *)callbackID
                       duration:(NSTimeInterval)jsDuration
               jsSchedulingTime:(nullable NSDate *)jsSchedulingTime
                        repeats:(BOOL)repeats;
- (void)deleteTimer:(double)timerID;

@end

NS_ASSUME_NONNULL_END
