/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTShadowView.h>

@class ABI50_0_0RCTRootShadowView;

@interface ABI50_0_0RCTShadowView (Internal)

@property (nonatomic, weak, readwrite) ABI50_0_0RCTRootShadowView *rootView;

@end
