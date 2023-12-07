/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTComponent.h>
#import <ABI50_0_0React/ABI50_0_0RCTTransformOrigin.h>
#import <ABI50_0_0yoga/ABI50_0_0YGEnums.h>

@class ABI50_0_0RCTShadowView;

@interface UIView (ABI50_0_0React) <ABI50_0_0RCTComponent>

/**
 * ABI50_0_0RCTComponent interface.
 */
- (NSArray<UIView *> *)ABI50_0_0ReactSubviews NS_REQUIRES_SUPER;
- (UIView *)ABI50_0_0ReactSuperview NS_REQUIRES_SUPER;
- (void)insertABI50_0_0ReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex NS_REQUIRES_SUPER;
- (void)removeABI50_0_0ReactSubview:(UIView *)subview NS_REQUIRES_SUPER;

/**
 * The native id of the view, used to locate view from native codes
 */
@property (nonatomic, copy) NSString *nativeID;

/**
 * Determines whether or not a view should ignore inverted colors or not. Used to set
 * UIView property accessibilityIgnoresInvertColors in iOS 11+.
 */
@property (nonatomic, assign) BOOL shouldAccessibilityIgnoresInvertColors;

/**
 * Layout direction of the view.
 * Internally backed to `semanticContentAttribute` property.
 * Defaults to `LeftToRight` in case of ambiguity.
 */
@property (nonatomic, assign) UIUserInterfaceLayoutDirection ABI50_0_0ReactLayoutDirection;

/**
 * Yoga `display` style property. Can be `flex` or `none`.
 * Defaults to `flex`.
 * May be used to temporary hide the view in a very efficient way.
 */
@property (nonatomic, assign) ABI50_0_0YGDisplay ABI50_0_0ReactDisplay;

/**
 * The z-index of the view.
 */
@property (nonatomic, assign) NSInteger ABI50_0_0ReactZIndex;

/**
 * Subviews sorted by z-index. Note that this method doesn't do any caching (yet)
 * and sorts all the views each call.
 */
- (NSArray<UIView *> *)ABI50_0_0ReactZIndexSortedSubviews;

/**
 * Updates the subviews array based on the ABI50_0_0ReactSubviews. Default behavior is
 * to insert the sortedABI50_0_0ReactSubviews into the UIView.
 */
- (void)didUpdateABI50_0_0ReactSubviews;

/**
 * Called each time props have been set.
 * The default implementation does nothing.
 */
- (void)didSetProps:(NSArray<NSString *> *)changedProps;

/**
 * Used by the UIIManager to set the view frame.
 * May be overridden to disable animation, etc.
 */
- (void)ABI50_0_0ReactSetFrame:(CGRect)frame;

/**
 * This method finds and returns the containing view controller for the view.
 */
- (UIViewController *)ABI50_0_0ReactViewController;

/**
 * This method attaches the specified controller as a child of the
 * the owning view controller of this view. Returns NO if no view
 * controller is found (which may happen if the view is not currently
 * attached to the view hierarchy).
 */
- (void)ABI50_0_0ReactAddControllerToClosestParent:(UIViewController *)controller;

/**
 * Focus manipulation.
 */
- (void)ABI50_0_0ReactFocus;
- (void)ABI50_0_0ReactFocusIfNeeded;
- (void)ABI50_0_0ReactBlur;

/**
 * Useful properties for computing layout.
 */
@property (nonatomic, readonly) UIEdgeInsets ABI50_0_0ReactBorderInsets;
@property (nonatomic, readonly) UIEdgeInsets ABI50_0_0ReactPaddingInsets;
@property (nonatomic, readonly) UIEdgeInsets ABI50_0_0ReactCompoundInsets;
@property (nonatomic, readonly) CGRect ABI50_0_0ReactContentFrame;

/**
 * The anchorPoint property doesn't work in the same way as on web - updating it updates the frame.
 * To work around this, we take both the transform and the transform-origin, and compute it ourselves
 */
@property (nonatomic, assign) CATransform3D ABI50_0_0ReactTransform;
@property (nonatomic, assign) ABI50_0_0RCTTransformOrigin ABI50_0_0ReactTransformOrigin;

/**
 * The (sub)view which represents this view in terms of accessibility.
 * ViewManager will apply all accessibility properties directly to this view.
 * May be overridden in view subclass which needs to be accessiblitywise
 * transparent in favour of some subview.
 * Defaults to `self`.
 */
@property (nonatomic, readonly) UIView *ABI50_0_0ReactAccessibilityElement;

/**
 * Accessibility properties
 */
@property (nonatomic, copy) NSString *accessibilityRole;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSDictionary<NSString *, id> *accessibilityState;
@property (nonatomic, copy) NSArray<NSDictionary *> *accessibilityActions;
@property (nonatomic, copy) NSDictionary *accessibilityValueInternal;
@property (nonatomic, copy) NSString *accessibilityLanguage;
@property (nonatomic) UIAccessibilityTraits accessibilityRoleTraits;
@property (nonatomic) UIAccessibilityTraits roleTraits;

/**
 * Used in debugging to get a description of the view hierarchy rooted at
 * the current view.
 */
- (NSString *)ABI50_0_0React_recursiveDescription;

@end
