/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGClipPath.h"

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricComponentsPlugins.h>
#import <react/renderer/components/rnsvg/ComponentDescriptors.h>
#import <react/renderer/components/view/conversions.h>
#import "ABI50_0_0RNSVGFabricConversions.h"
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@implementation ABI50_0_0RNSVGClipPath

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
using namespace ABI50_0_0facebook::ABI50_0_0React;

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ABI50_0_0RNSVGClipPathProps>();
    _props = defaultProps;
  }
  return self;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ABI50_0_0RNSVGClipPathComponentDescriptor>();
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &newProps = static_cast<const ABI50_0_0RNSVGClipPathProps &>(*props);
  setCommonNodeProps(newProps, self);
  _props = std::static_pointer_cast<ABI50_0_0RNSVGClipPathProps const>(props);
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

- (void)parseReference
{
  self.dirty = false;
  [self.svgView defineClipPath:self clipPathName:self.name];
}

- (BOOL)isSimpleClipPath
{
  NSArray<ABI50_0_0RNSVGView *> *children = self.subviews;
  if (children.count == 1) {
    ABI50_0_0RNSVGView *child = children[0];
    if ([child class] != [ABI50_0_0RNSVGGroup class]) {
      return true;
    }
  }
  return false;
}

@end

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RNSVGClipPathCls(void)
{
  return ABI50_0_0RNSVGClipPath.class;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
