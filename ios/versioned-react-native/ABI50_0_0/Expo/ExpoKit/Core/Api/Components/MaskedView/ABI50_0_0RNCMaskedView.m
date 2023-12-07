/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNCMaskedView.h"

#import <ABI50_0_0React/ABI50_0_0UIView+React.h>

@implementation ABI50_0_0RNCMaskedView

- (void)didUpdateABI50_0_0ReactSubviews
{
  // ABI50_0_0RNCMaskedView expects that the first subview rendered is the mask.
  UIView *maskView = [self.ABI50_0_0ReactSubviews firstObject];
  self.maskView = maskView;

  // Add the other subviews to the view hierarchy
  for (NSUInteger i = 1; i < self.ABI50_0_0ReactSubviews.count; i++) {
    UIView *subview = [self.ABI50_0_0ReactSubviews objectAtIndex:i];
    [self addSubview:subview];
  }
}

- (void)displayLayer:(CALayer *)layer
{
  // ABI50_0_0RCTView uses displayLayer to do border rendering.
  // We don't need to do that in ABI50_0_0RNCMaskedView, so we
  // stub this method and override the default implementation.
}

@end
