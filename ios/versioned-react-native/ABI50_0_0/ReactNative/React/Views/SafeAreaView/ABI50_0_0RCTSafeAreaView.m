/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTSafeAreaView.h"

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>

#import "ABI50_0_0RCTSafeAreaViewLocalData.h"

@implementation ABI50_0_0RCTSafeAreaView {
  __weak ABI50_0_0RCTBridge *_bridge;
  UIEdgeInsets _currentSafeAreaInsets;
}

- (instancetype)initWithBridge:(ABI50_0_0RCTBridge *)bridge
{
  if (self = [super initWithFrame:CGRectZero]) {
    _bridge = bridge;
  }

  return self;
}

ABI50_0_0RCT_NOT_IMPLEMENTED(-(instancetype)initWithCoder : (NSCoder *)decoder)
ABI50_0_0RCT_NOT_IMPLEMENTED(-(instancetype)initWithFrame : (CGRect)frame)

- (NSString *)description
{
  NSString *superDescription = [super description];

  // Cutting the last `>` character.
  if (superDescription.length > 0 && [superDescription characterAtIndex:superDescription.length - 1] == '>') {
    superDescription = [superDescription substringToIndex:superDescription.length - 1];
  }

  return [NSString stringWithFormat:@"%@; safeAreaInsets = %@; appliedSafeAreaInsets = %@>",
                                    superDescription,
                                    NSStringFromUIEdgeInsets(self.safeAreaInsets),
                                    NSStringFromUIEdgeInsets(_currentSafeAreaInsets)];
}

static BOOL UIEdgeInsetsEqualToEdgeInsetsWithThreshold(UIEdgeInsets insets1, UIEdgeInsets insets2, CGFloat threshold)
{
  return ABS(insets1.left - insets2.left) <= threshold && ABS(insets1.right - insets2.right) <= threshold &&
      ABS(insets1.top - insets2.top) <= threshold && ABS(insets1.bottom - insets2.bottom) <= threshold;
}

- (void)safeAreaInsetsDidChange
{
  [self setSafeAreaInsets:self.safeAreaInsets];
}

- (void)setSafeAreaInsets:(UIEdgeInsets)safeAreaInsets
{
  // Relayout with different padding may result in a close but slightly different result, amplified by Yoga rounding to
  // physical pixel grid. To avoid infinite relayout, allow one physical pixel of difference, along with small amount of
  // extra tolerance for FP error.
  CGFloat tolerance = 1.0 / ABI50_0_0RCTScreenScale() + 0.01;

  if (UIEdgeInsetsEqualToEdgeInsetsWithThreshold(safeAreaInsets, _currentSafeAreaInsets, tolerance)) {
    return;
  }

  _currentSafeAreaInsets = safeAreaInsets;

  ABI50_0_0RCTSafeAreaViewLocalData *localData = [[ABI50_0_0RCTSafeAreaViewLocalData alloc] initWithInsets:safeAreaInsets];
  [_bridge.uiManager setLocalData:localData forView:self];
}

@end
