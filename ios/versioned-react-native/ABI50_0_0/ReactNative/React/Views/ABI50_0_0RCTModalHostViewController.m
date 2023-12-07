/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTModalHostViewController.h"

#import "ABI50_0_0RCTLog.h"
#import "ABI50_0_0RCTModalHostView.h"

@implementation ABI50_0_0RCTModalHostViewController {
  CGRect _lastViewFrame;
  UIStatusBarStyle _preferredStatusBarStyle;
  BOOL _preferredStatusBarHidden;
}

- (instancetype)init
{
  if (!(self = [super init])) {
    return nil;
  }

  self.modalInPresentation = YES;

  _preferredStatusBarStyle = [ABI50_0_0RCTSharedApplication() statusBarStyle];
  _preferredStatusBarHidden = [ABI50_0_0RCTSharedApplication() isStatusBarHidden];

  return self;
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];

  if (self.boundsDidChangeBlock && !CGRectEqualToRect(_lastViewFrame, self.view.frame)) {
    self.boundsDidChangeBlock(self.view.bounds);
    _lastViewFrame = self.view.frame;
  }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return _preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
  return _preferredStatusBarHidden;
}

#if ABI50_0_0RCT_DEV
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  UIInterfaceOrientationMask appSupportedOrientationsMask =
      [ABI50_0_0RCTSharedApplication() supportedInterfaceOrientationsForWindow:[ABI50_0_0RCTSharedApplication() keyWindow]];
  if (!(_supportedInterfaceOrientations & appSupportedOrientationsMask)) {
    ABI50_0_0RCTLogError(
        @"Modal was presented with 0x%x orientations mask but the application only supports 0x%x."
        @"Add more interface orientations to your app's Info.plist to fix this."
        @"NOTE: This will crash in non-dev mode.",
        (unsigned)_supportedInterfaceOrientations,
        (unsigned)appSupportedOrientationsMask);
    return UIInterfaceOrientationMaskAll;
  }

  return _supportedInterfaceOrientations;
}
#endif // ABI50_0_0RCT_DEV

@end
