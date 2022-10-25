/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI47_0_0RNCSegmentedControlManager.h"

#import "ABI47_0_0RNCSegmentedControl.h"
#import <ABI47_0_0React/ABI47_0_0RCTBridge.h>
#import <ABI47_0_0React/ABI47_0_0RCTConvert.h>

@implementation ABI47_0_0RNCSegmentedControlManager

ABI47_0_0RCT_EXPORT_MODULE()

- (UIView *)view {
  return [ABI47_0_0RNCSegmentedControl new];
}

ABI47_0_0RCT_EXPORT_VIEW_PROPERTY(values, NSArray)
ABI47_0_0RCT_EXPORT_VIEW_PROPERTY(selectedIndex, NSInteger)
ABI47_0_0RCT_EXPORT_VIEW_PROPERTY(tintColor, UIColor)
ABI47_0_0RCT_EXPORT_VIEW_PROPERTY(backgroundColor, UIColor)
ABI47_0_0RCT_EXPORT_VIEW_PROPERTY(momentary, BOOL)
ABI47_0_0RCT_EXPORT_VIEW_PROPERTY(enabled, BOOL)
ABI47_0_0RCT_EXPORT_VIEW_PROPERTY(onChange, ABI47_0_0RCTBubblingEventBlock)
ABI47_0_0RCT_EXPORT_VIEW_PROPERTY(appearance, NSString)

ABI47_0_0RCT_CUSTOM_VIEW_PROPERTY(fontStyle, NSObject, ABI47_0_0RNCSegmentedControl) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && defined(__IPHONE_13_0) &&      \
    __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
  if (@available(iOS 13.0, *)) {
    if (json) {
      UIColor *color = json[@"color"] ? [ABI47_0_0RCTConvert UIColor:json[@"color"]]
                                      : UIColor.labelColor;
      NSInteger fontSize =
          json[@"fontSize"] ? [ABI47_0_0RCTConvert NSInteger:json[@"fontSize"]] : 13.0;
      UIFont *font = [UIFont systemFontOfSize:fontSize];
      if (json[@"fontFamily"]) {
        UIFont *tempFont = [UIFont fontWithName:json[@"fontFamily"]
                                           size:fontSize];
        if (tempFont != nil) {
          font = tempFont;
        }
      }

      NSDictionary *attributes = [NSDictionary
          dictionaryWithObjectsAndKeys:font, NSFontAttributeName, color,
                                       NSForegroundColorAttributeName, nil];
      [view setTitleTextAttributes:attributes forState:UIControlStateNormal];
    }
  }
#endif
}

ABI47_0_0RCT_CUSTOM_VIEW_PROPERTY(activeFontStyle, NSObject, ABI47_0_0RNCSegmentedControl) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && defined(__IPHONE_13_0) &&      \
    __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
  if (@available(iOS 13.0, *)) {
    if (json) {
      UIColor *color = json[@"color"] ? [ABI47_0_0RCTConvert UIColor:json[@"color"]]
                                      : UIColor.labelColor;
      NSInteger fontSize =
          json[@"fontSize"] ? [ABI47_0_0RCTConvert NSInteger:json[@"fontSize"]] : 13.0;
      UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
      if (json[@"fontFamily"]) {
        font = [UIFont fontWithName:json[@"fontFamily"] size:fontSize];
      }
      NSDictionary *attributes = [NSDictionary
          dictionaryWithObjectsAndKeys:font, NSFontAttributeName, color,
                                       NSForegroundColorAttributeName, nil];
      [view setTitleTextAttributes:attributes forState:UIControlStateSelected];
    }
  }
#endif
}

@end
