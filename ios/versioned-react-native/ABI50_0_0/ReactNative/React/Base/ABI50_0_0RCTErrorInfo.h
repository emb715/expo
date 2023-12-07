/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

@class ABI50_0_0RCTJSStackFrame;

/**
 * An ObjC wrapper for ABI50_0_0React Native errors.
 */
@interface ABI50_0_0RCTErrorInfo : NSObject
@property (nonatomic, copy, readonly) NSString *errorMessage;
@property (nonatomic, copy, readonly) NSArray<ABI50_0_0RCTJSStackFrame *> *stack;

- (instancetype)initWithErrorMessage:(NSString *)errorMessage stack:(NSArray<ABI50_0_0RCTJSStackFrame *> *)stack;

@end
