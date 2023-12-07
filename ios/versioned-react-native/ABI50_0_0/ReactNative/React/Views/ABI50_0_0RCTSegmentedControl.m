/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTSegmentedControl.h"

#import "ABI50_0_0RCTConvert.h"
#import "ABI50_0_0UIView+React.h"

@implementation ABI50_0_0RCTSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    _selectedIndex = self.selectedSegmentIndex;
    [self addTarget:self action:@selector(didChange) forControlEvents:UIControlEventValueChanged];
  }
  return self;
}

- (void)setValues:(NSArray<NSString *> *)values
{
  _values = [values copy];
  [self removeAllSegments];
  for (NSString *value in values) {
    [self insertSegmentWithTitle:value atIndex:self.numberOfSegments animated:NO];
  }
  super.selectedSegmentIndex = _selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
  _selectedIndex = selectedIndex;
  super.selectedSegmentIndex = selectedIndex;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
  [super setBackgroundColor:backgroundColor];
}

- (void)setTextColor:(UIColor *)textColor
{
  [self setTitleTextAttributes:@{NSForegroundColorAttributeName : textColor} forState:UIControlStateNormal];
}

- (void)setTintColor:(UIColor *)tintColor
{
  [super setTintColor:tintColor];

  [self setSelectedSegmentTintColor:tintColor];
  [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}
                      forState:UIControlStateSelected];
  [self setTitleTextAttributes:@{NSForegroundColorAttributeName : tintColor} forState:UIControlStateNormal];
}

- (void)didChange
{
  _selectedIndex = self.selectedSegmentIndex;
  if (_onChange) {
    _onChange(@{@"value" : [self titleForSegmentAtIndex:_selectedIndex], @"selectedSegmentIndex" : @(_selectedIndex)});
  }
}

@end
