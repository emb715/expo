/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

@protocol ABI50_0_0RCTBridgeModule;
@class ABI50_0_0RCTModuleData;

@interface ABI50_0_0RCTDisplayLink : NSObject

- (instancetype)init;
- (void)invalidate;
- (void)registerModuleForFrameUpdates:(id<ABI50_0_0RCTBridgeModule>)module withModuleData:(ABI50_0_0RCTModuleData *)moduleData;
- (void)addToRunLoop:(NSRunLoop *)runLoop;

@end
