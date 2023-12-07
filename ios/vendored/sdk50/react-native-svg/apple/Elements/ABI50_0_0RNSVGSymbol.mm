/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */
#import "ABI50_0_0RNSVGSymbol.h"
#import "ABI50_0_0RNSVGViewBox.h"

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricComponentsPlugins.h>
#import <react/renderer/components/rnsvg/ComponentDescriptors.h>
#import <react/renderer/components/view/conversions.h>
#import "ABI50_0_0RNSVGFabricConversions.h"
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@implementation ABI50_0_0RNSVGSymbol

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
using namespace ABI50_0_0facebook::ABI50_0_0React;

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ABI50_0_0RNSVGSymbolProps>();
    _props = defaultProps;
  }
  return self;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ABI50_0_0RNSVGSymbolComponentDescriptor>();
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &newProps = static_cast<const ABI50_0_0RNSVGSymbolProps &>(*props);

  self.minX = newProps.minX;
  self.minY = newProps.minY;
  self.vbWidth = newProps.vbWidth;
  self.vbHeight = newProps.vbHeight;
  self.align = ABI50_0_0RCTNSStringFromStringNilIfEmpty(newProps.align);
  self.meetOrSlice = intToRNSVGVBMOS(newProps.meetOrSlice);

  setCommonGroupProps(newProps, self);
  _props = std::static_pointer_cast<ABI50_0_0RNSVGSymbolProps const>(props);
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];

  _minX = 0;
  _minY = 0;
  _vbWidth = 0;
  _vbHeight = 0;
  _align = nil;
  _meetOrSlice = kRNSVGVBMOSMeet;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

- (void)setMinX:(CGFloat)minX
{
  if (minX == _minX) {
    return;
  }

  [self invalidate];
  _minX = minX;
}

- (void)setMinY:(CGFloat)minY
{
  if (minY == _minY) {
    return;
  }

  [self invalidate];
  _minY = minY;
}

- (void)setVbWidth:(CGFloat)vbWidth
{
  if (vbWidth == _vbWidth) {
    return;
  }

  [self invalidate];
  _vbWidth = vbWidth;
}

- (void)setVbHeight:(CGFloat)vbHeight
{
  if (_vbHeight == vbHeight) {
    return;
  }

  [self invalidate];
  _vbHeight = vbHeight;
}

- (void)setAlign:(NSString *)align
{
  if ([align isEqualToString:_align]) {
    return;
  }

  [self invalidate];
  _align = align;
}

- (void)setMeetOrSlice:(ABI50_0_0RNSVGVBMOS)meetOrSlice
{
  if (meetOrSlice == _meetOrSlice) {
    return;
  }

  [self invalidate];
  _meetOrSlice = meetOrSlice;
}

- (void)renderTo:(CGContextRef)context rect:(CGRect)rect
{
  self.dirty = false;
  // Do not render Symbol
}

- (void)renderSymbolTo:(CGContextRef)context width:(CGFloat)width height:(CGFloat)height
{
  CGRect eRect = CGRectMake(0, 0, width, height);
  if (self.align) {
    CGAffineTransform viewBoxTransform =
        [ABI50_0_0RNSVGViewBox getTransform:CGRectMake(self.minX, self.minY, self.vbWidth, self.vbHeight)
                             eRect:eRect
                             align:self.align
                       meetOrSlice:self.meetOrSlice];

    CGContextConcatCTM(context, viewBoxTransform);
  }
  [self renderGroupTo:context rect:eRect];
}

@end

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RNSVGSymbolCls(void)
{
  return ABI50_0_0RNSVGSymbol.class;
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
