// Copyright 2023-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXJavaScriptRuntime.h>

#ifdef __cplusplus
#import <ABI50_0_0jsi/ABI50_0_0jsi.h>

namespace jsi = ABI50_0_0facebook::jsi;
#endif // __cplusplus

NS_SWIFT_NAME(RawJavaScriptFunction)
@interface ABI50_0_0EXRawJavaScriptFunction : NSObject

#ifdef __cplusplus
- (nonnull instancetype)initWith:(std::shared_ptr<jsi::Function>)function
                         runtime:(nonnull ABI50_0_0EXJavaScriptRuntime *)runtime;
#endif // __cplusplus

- (nonnull ABI50_0_0EXJavaScriptValue *)callWithArguments:(nonnull NSArray<id> *)arguments
                                      thisObject:(nullable ABI50_0_0EXJavaScriptObject *)thisObject
                                   asConstructor:(BOOL)asConstructor;

@end
