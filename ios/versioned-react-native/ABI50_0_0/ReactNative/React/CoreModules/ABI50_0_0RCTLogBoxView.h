/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfacePresenterStub.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfaceView.h>
#import <UIKit/UIKit.h>

@interface ABI50_0_0RCTLogBoxView : UIWindow

- (instancetype)initWithFrame:(CGRect)frame;

- (void)createRootViewController:(UIView *)view;

- (instancetype)initWithWindow:(UIWindow *)window bridge:(ABI50_0_0RCTBridge *)bridge;
- (instancetype)initWithWindow:(UIWindow *)window surfacePresenter:(id<ABI50_0_0RCTSurfacePresenterStub>)surfacePresenter;

- (void)show;

@end
