/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridgeProxy.h>
#import <ABI50_0_0React/ABI50_0_0RCTURLRequestHandler.h>

@interface ABI50_0_0RCTImageStoreManager : NSObject <ABI50_0_0RCTURLRequestHandler>

/**
 * Set and get cached image data asynchronously. It is safe to call these from any
 * thread. The callbacks will be called on an unspecified thread.
 */
- (void)removeImageForTag:(NSString *)imageTag withBlock:(void (^)(void))block;
- (void)storeImageData:(NSData *)imageData withBlock:(void (^)(NSString *imageTag))block;
- (void)getImageDataForTag:(NSString *)imageTag withBlock:(void (^)(NSData *imageData))block;

/**
 * Convenience method to store an image directly (image is converted to data
 * internally, so any metadata such as scale or orientation will be lost).
 */
- (void)storeImage:(UIImage *)image withBlock:(void (^)(NSString *imageTag))block;

@end

@interface ABI50_0_0RCTImageStoreManager (Deprecated)

/**
 * These methods are deprecated - use the data-based alternatives instead.
 */
- (NSString *)storeImage:(UIImage *)image __deprecated;
- (UIImage *)imageForTag:(NSString *)imageTag __deprecated;
- (void)getImageForTag:(NSString *)imageTag withBlock:(void (^)(UIImage *image))block __deprecated;

@end

@interface ABI50_0_0RCTBridge (ABI50_0_0RCTImageStoreManager)

@property (nonatomic, readonly) ABI50_0_0RCTImageStoreManager *imageStoreManager;

@end

@interface ABI50_0_0RCTBridgeProxy (ABI50_0_0RCTImageStoreManager)

@property (nonatomic, readonly) ABI50_0_0RCTImageStoreManager *imageStoreManager;

@end
