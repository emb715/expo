/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTRootComponentView.h"

#import <ABI50_0_0React/renderer/components/root/ABI50_0_0RootComponentDescriptor.h>
#import <ABI50_0_0React/renderer/components/root/ABI50_0_0RootProps.h>
#import "ABI50_0_0RCTConversions.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

@implementation ABI50_0_0RCTRootComponentView

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const RootProps>();
    _props = defaultProps;
  }

  return self;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<RootComponentDescriptor>();
}

@end
