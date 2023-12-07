// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>

// Swift classes need forward-declaration in the headers.
@class ABI50_0_0EXAppContext;
@class ABI50_0_0EXRuntime;

@interface ABI50_0_0EXJavaScriptRuntimeManager : NSObject

/**
 Gets the JS runtime from the given bridge. May return `nil` when
 the runtime is not available yet or the remote debugging is enabled.
 */
+ (nullable ABI50_0_0EXRuntime *)runtimeFromBridge:(nonnull ABI50_0_0RCTBridge *)bridge NS_SWIFT_NAME(runtime(fromBridge:));

/**
 Installs ExpoModules host object in the runtime of the given app context.
 Returns a bool value whether the installation succeeded.
 */
+ (BOOL)installExpoModulesHostObject:(nonnull ABI50_0_0EXAppContext *)appContext;

@end
