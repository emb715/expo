/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>
#import <ABI50_0_0yoga/ABI50_0_0Yoga.h>

NS_ASSUME_NONNULL_BEGIN

@class ABI50_0_0RCTShadowView;

typedef NS_ENUM(NSInteger, ABI50_0_0RCTDisplayType) {
  ABI50_0_0RCTDisplayTypeNone,
  ABI50_0_0RCTDisplayTypeFlex,
  ABI50_0_0RCTDisplayTypeInline,
};

struct ABI50_0_0RCTLayoutMetrics {
  CGRect frame;
  CGRect contentFrame;
  UIEdgeInsets borderWidth;
  ABI50_0_0RCTDisplayType displayType;
  UIUserInterfaceLayoutDirection layoutDirection;
};
typedef struct CG_BOXABLE ABI50_0_0RCTLayoutMetrics ABI50_0_0RCTLayoutMetrics;

struct ABI50_0_0RCTLayoutContext {
  CGPoint absolutePosition;
  __unsafe_unretained NSPointerArray *_Nonnull affectedShadowViews;
  __unsafe_unretained NSHashTable<NSString *> *_Nonnull other;
};
typedef struct CG_BOXABLE ABI50_0_0RCTLayoutContext ABI50_0_0RCTLayoutContext;

static inline BOOL ABI50_0_0RCTLayoutMetricsEqualToLayoutMetrics(ABI50_0_0RCTLayoutMetrics a, ABI50_0_0RCTLayoutMetrics b)
{
  return CGRectEqualToRect(a.frame, b.frame) && CGRectEqualToRect(a.contentFrame, b.contentFrame) &&
      UIEdgeInsetsEqualToEdgeInsets(a.borderWidth, b.borderWidth) && a.displayType == b.displayType &&
      a.layoutDirection == b.layoutDirection;
}

ABI50_0_0RCT_EXTERN ABI50_0_0RCTLayoutMetrics ABI50_0_0RCTLayoutMetricsFromYogaNode(ABI50_0_0YGNodeRef yogaNode);

/**
 * Converts float values between Yoga and CoreGraphics representations,
 * especially in terms of edge cases.
 */
ABI50_0_0RCT_EXTERN float ABI50_0_0RCTYogaFloatFromCoreGraphicsFloat(CGFloat value);
ABI50_0_0RCT_EXTERN CGFloat ABI50_0_0RCTCoreGraphicsFloatFromYogaFloat(float value);

/**
 * Converts compound `ABI50_0_0YGValue` to simple `CGFloat` value.
 */
ABI50_0_0RCT_EXTERN CGFloat ABI50_0_0RCTCoreGraphicsFloatFromYogaValue(ABI50_0_0YGValue value, CGFloat baseFloatValue);

/**
 * Converts `ABI50_0_0YGDirection` to `UIUserInterfaceLayoutDirection` and vise versa.
 */
ABI50_0_0RCT_EXTERN ABI50_0_0YGDirection ABI50_0_0RCTYogaLayoutDirectionFromUIKitLayoutDirection(UIUserInterfaceLayoutDirection direction);
ABI50_0_0RCT_EXTERN UIUserInterfaceLayoutDirection ABI50_0_0RCTUIKitLayoutDirectionFromYogaLayoutDirection(ABI50_0_0YGDirection direction);

/**
 * Converts `ABI50_0_0YGDisplay` to `ABI50_0_0RCTDisplayType` and vise versa.
 */
ABI50_0_0RCT_EXTERN ABI50_0_0YGDisplay ABI50_0_0RCTYogaDisplayTypeFromABI50_0_0ReactDisplayType(ABI50_0_0RCTDisplayType displayType);
ABI50_0_0RCT_EXTERN ABI50_0_0RCTDisplayType ABI50_0_0RCTABI50_0_0ReactDisplayTypeFromYogaDisplayType(ABI50_0_0YGDisplay displayType);

NS_ASSUME_NONNULL_END
