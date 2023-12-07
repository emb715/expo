/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcherProtocol.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventEmitter.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfacePresenterStub.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManagerObserverCoordinator.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManagerUtils.h>

#import "ABI50_0_0RCTValueAnimatedNode.h"

// TODO T69437152 @petetheheat - Delete this fork when Fabric ships to 100%.
// NOTE: This module is temporarily forked (see ABI50_0_0RCTNativeAnimatedTurboModule).
// When making any changes, be sure to apply them to the fork as well.
@interface ABI50_0_0RCTNativeAnimatedModule : ABI50_0_0RCTEventEmitter <
                                         ABI50_0_0RCTBridgeModule,
                                         ABI50_0_0RCTValueAnimatedNodeObserver,
                                         ABI50_0_0RCTEventDispatcherObserver,
                                         ABI50_0_0RCTUIManagerObserver,
                                         ABI50_0_0RCTSurfacePresenterObserver>

@end
