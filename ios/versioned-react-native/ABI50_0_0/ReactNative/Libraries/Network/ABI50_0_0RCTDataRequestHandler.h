/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTInvalidating.h>
#import <ABI50_0_0React/ABI50_0_0RCTURLRequestHandler.h>

/**
 * This is the default ABI50_0_0RCTURLRequestHandler implementation for data URL requests.
 */
@interface ABI50_0_0RCTDataRequestHandler : NSObject <ABI50_0_0RCTURLRequestHandler, ABI50_0_0RCTInvalidating>

@end
