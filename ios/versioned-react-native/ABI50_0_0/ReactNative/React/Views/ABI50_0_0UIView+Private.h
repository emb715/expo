/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

@interface UIView (ABI50_0_0Private)

// remove clipped subviews implementation
- (void)ABI50_0_0React_remountAllSubviews;
- (void)ABI50_0_0React_updateClippedSubviewsWithClipRect:(CGRect)clipRect relativeToView:(UIView *)clipView;
- (UIView *)ABI50_0_0React_findClipView;

@end
