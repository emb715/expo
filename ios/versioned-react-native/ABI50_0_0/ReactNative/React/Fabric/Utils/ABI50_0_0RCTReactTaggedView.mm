/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTReactTaggedView.h"

@implementation ABI50_0_0RCTReactTaggedView

+ (ABI50_0_0RCTReactTaggedView *)wrap:(UIView *)view
{
  return [[ABI50_0_0RCTReactTaggedView alloc] initWithView:view];
}

- (instancetype)initWithView:(UIView *)view
{
  if (self = [super init]) {
    _view = view;
    _tag = view.tag;
  }
  return self;
}

- (nullable UIView *)view
{
  if (_view.tag == _tag) {
    return _view;
  }
  return nil;
}

- (NSInteger)tag
{
  return _tag;
}

- (BOOL)isEqual:(id)other
{
  if (other == self) {
    return YES;
  }
  if (!other || ![other isKindOfClass:[self class]]) {
    return NO;
  }
  return _tag == [other tag];
}

- (NSUInteger)hash
{
  return _tag;
}

@end
