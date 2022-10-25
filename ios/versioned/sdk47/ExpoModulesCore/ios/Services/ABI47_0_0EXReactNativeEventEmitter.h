// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI47_0_0React/ABI47_0_0RCTEventEmitter.h>

#import <ABI47_0_0ExpoModulesCore/ABI47_0_0EXInternalModule.h>
#import <ABI47_0_0ExpoModulesCore/ABI47_0_0EXEventEmitterService.h>
#import <ABI47_0_0ExpoModulesCore/ABI47_0_0EXModuleRegistryConsumer.h>
#import <ABI47_0_0ExpoModulesCore/ABI47_0_0EXBridgeModule.h>

// Swift compatibility headers (e.g. `ExpoModulesCore-Swift.h`) are not available in headers,
// so we use class forward declaration here. Swift header must be imported in the `.m` file.
@class ABI47_0_0EXAppContext;

@interface ABI47_0_0EXReactNativeEventEmitter : ABI47_0_0RCTEventEmitter <ABI47_0_0EXInternalModule, ABI47_0_0EXBridgeModule, ABI47_0_0EXModuleRegistryConsumer, ABI47_0_0EXEventEmitterService>

@property (nonatomic, strong) ABI47_0_0EXAppContext *appContext;

@end
