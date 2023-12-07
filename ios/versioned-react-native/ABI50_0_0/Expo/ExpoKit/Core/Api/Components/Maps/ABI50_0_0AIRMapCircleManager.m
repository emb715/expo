/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ABI50_0_0AIRMapCircleManager.h"

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTConvert+CoreLocation.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>
#import <ABI50_0_0React/ABI50_0_0UIView+React.h>
#import "ABI50_0_0AIRMapMarker.h"
#import "ABI50_0_0AIRMapCircle.h"

@interface ABI50_0_0AIRMapCircleManager()

@end

@implementation ABI50_0_0AIRMapCircleManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
    ABI50_0_0AIRMapCircle *circle = [ABI50_0_0AIRMapCircle new];
    return circle;
}

ABI50_0_0RCT_REMAP_VIEW_PROPERTY(center, centerCoordinate, CLLocationCoordinate2D)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(radius, CLLocationDistance)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(fillColor, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeColor, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(strokeWidth, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(lineCap, CGLineCap)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(lineJoin, CGLineJoin)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(miterLimit, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(lineDashPhase, CGFloat)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(lineDashPattern, NSArray)

// NOTE(lmr):
// for now, onPress events for overlays will be left unimplemented. Seems it is possible with some work, but
// it is difficult to achieve in both ios and android so I decided to leave it out.
//ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPress, ABI50_0_0RCTBubblingEventBlock)

@end
