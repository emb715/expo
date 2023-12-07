/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

// NOTE: This entire file should be codegen'ed.

#import <vector>

#import <Foundation/Foundation.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>

#import <ABI50_0_0ReactCommon/ABI50_0_0RCTTurboModule.h>

/**
 * The ObjC protocol based on the JS Flow type for SampleTurboModule.
 */
@protocol ABI50_0_0NativeSampleTurboModuleSpec <ABI50_0_0RCTBridgeModule, ABI50_0_0RCTTurboModule>

- (void)voidFunc;
- (NSNumber *)getBool:(BOOL)arg;
- (NSNumber *)getEnum:(double)arg;
- (NSNumber *)getNumber:(double)arg;
- (NSString *)getString:(NSString *)arg;
- (NSArray<id<NSObject>> *)getArray:(NSArray *)arg;
- (NSDictionary *)getObject:(NSDictionary *)arg;
- (NSDictionary *)getUnsafeObject:(NSDictionary *)arg;
- (NSNumber *)getRootTag:(double)arg;
- (NSDictionary *)getValue:(double)x y:(NSString *)y z:(NSDictionary *)z;
- (void)getValueWithCallback:(ABI50_0_0RCTResponseSenderBlock)callback;
- (void)getValueWithPromise:(BOOL)error resolve:(ABI50_0_0RCTPromiseResolveBlock)resolve reject:(ABI50_0_0RCTPromiseRejectBlock)reject;
- (void)voidFuncThrows;
- (NSDictionary *)getObjectThrows:(NSDictionary *)arg;
- (void)promiseThrows:(BOOL)error resolve:(ABI50_0_0RCTPromiseResolveBlock)resolve reject:(ABI50_0_0RCTPromiseRejectBlock)reject;
- (void)voidFuncAssert;
- (NSDictionary *)getObjectAssert:(NSDictionary *)arg;
- (void)promiseAssert:(BOOL)error resolve:(ABI50_0_0RCTPromiseResolveBlock)resolve reject:(ABI50_0_0RCTPromiseRejectBlock)reject;
- (NSDictionary *)constantsToExport;
- (NSDictionary *)getConstants;

@end

namespace ABI50_0_0facebook::ABI50_0_0React {

/**
 * The iOS TurboModule impl specific to SampleTurboModule.
 */
class JSI_EXPORT NativeSampleTurboModuleSpecJSI : public ObjCTurboModule {
 public:
  NativeSampleTurboModuleSpecJSI(const ObjCTurboModule::InitParams &params);
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
