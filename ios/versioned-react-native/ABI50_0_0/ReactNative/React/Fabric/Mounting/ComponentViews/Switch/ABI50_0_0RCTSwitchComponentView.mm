/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTSwitchComponentView.h"

#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>

#import <ABI50_0_0React/renderer/components/rncore/ABI50_0_0ComponentDescriptors.h>
#import <ABI50_0_0React/renderer/components/rncore/ABI50_0_0EventEmitters.h>
#import <ABI50_0_0React/renderer/components/rncore/ABI50_0_0Props.h>
#import <ABI50_0_0React/renderer/components/rncore/ABI50_0_0RCTComponentViewHelpers.h>

#import "ABI50_0_0RCTFabricComponentsPlugins.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

@interface ABI50_0_0RCTSwitchComponentView () <ABI50_0_0RCTSwitchViewProtocol>
@end

@implementation ABI50_0_0RCTSwitchComponentView {
  UISwitch *_switchView;
  BOOL _isInitialValueSet;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const SwitchProps>();
    _props = defaultProps;

    _switchView = [[UISwitch alloc] initWithFrame:self.bounds];

    [_switchView addTarget:self action:@selector(onChange:) forControlEvents:UIControlEventValueChanged];

    self.contentView = _switchView;
  }

  return self;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

- (void)prepareForRecycle
{
  [super prepareForRecycle];
  _isInitialValueSet = NO;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<SwitchComponentDescriptor>();
}

- (void)updateProps:(const Props::Shared &)props oldProps:(const Props::Shared &)oldProps
{
  const auto &oldSwitchProps = static_cast<const SwitchProps &>(*_props);
  const auto &newSwitchProps = static_cast<const SwitchProps &>(*props);

  // `value`
  if (oldSwitchProps.value != newSwitchProps.value) {
    BOOL shouldAnimate = _isInitialValueSet == YES;
    [_switchView setOn:newSwitchProps.value animated:shouldAnimate];
    _isInitialValueSet = YES;
  }

  // `disabled`
  if (oldSwitchProps.disabled != newSwitchProps.disabled) {
    _switchView.enabled = !newSwitchProps.disabled;
  }

  // `tintColor`
  if (oldSwitchProps.tintColor != newSwitchProps.tintColor) {
    _switchView.tintColor = ABI50_0_0RCTUIColorFromSharedColor(newSwitchProps.tintColor);
  }

  // `onTintColor
  if (oldSwitchProps.onTintColor != newSwitchProps.onTintColor) {
    _switchView.onTintColor = ABI50_0_0RCTUIColorFromSharedColor(newSwitchProps.onTintColor);
  }

  // `thumbTintColor`
  if (oldSwitchProps.thumbTintColor != newSwitchProps.thumbTintColor) {
    _switchView.thumbTintColor = ABI50_0_0RCTUIColorFromSharedColor(newSwitchProps.thumbTintColor);
  }

  [super updateProps:props oldProps:oldProps];
}

- (void)onChange:(UISwitch *)sender
{
  const auto &props = static_cast<const SwitchProps &>(*_props);
  if (props.value == sender.on) {
    return;
  }

  static_cast<const SwitchEventEmitter &>(*_eventEmitter)
      .onChange(SwitchEventEmitter::OnChange{.value = static_cast<bool>(sender.on)});
}

#pragma mark - Native Commands

- (void)handleCommand:(const NSString *)commandName args:(const NSArray *)args
{
  ABI50_0_0RCTSwitchHandleCommand(self, commandName, args);
}

- (void)setValue:(BOOL)value
{
  [_switchView setOn:value animated:YES];
}

@end

Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RCTSwitchCls(void)
{
  return ABI50_0_0RCTSwitchComponentView.class;
}
