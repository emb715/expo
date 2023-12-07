// Copyright 2018-present 650 Industries. All rights reserved.

#import <ABI50_0_0UMAppLoader/ABI50_0_0UMAppLoaderProvider.h>
#import <ABI50_0_0UMAppLoader/ABI50_0_0UMAppLoaderInterface.h>

static NSMutableDictionary<NSString *, Class> *ABI50_0_0UMProvidedAppLoaderClasses;

extern void ABI50_0_0UMRegisterAppLoader(NSString *, Class);
extern void ABI50_0_0UMRegisterAppLoader(NSString *loaderName, Class loaderClass)
{
  if ([loaderClass conformsToProtocol:@protocol(ABI50_0_0UMAppLoaderInterface)]) {
    if (!ABI50_0_0UMProvidedAppLoaderClasses) {
      ABI50_0_0UMProvidedAppLoaderClasses = [NSMutableDictionary new];
    }
    ABI50_0_0UMProvidedAppLoaderClasses[loaderName] = loaderClass;
  } else {
    NSLog(@"ABI50_0_0UMAppLoader class (%@) doesn't conform to the ABI50_0_0UMAppLoaderInterface protocol.", NSStringFromClass(loaderClass));
  }
}

@implementation ABI50_0_0UMAppLoaderProvider

- (nullable id<ABI50_0_0UMAppLoaderInterface>)createAppLoader:(NSString *)loaderName
{
  Class loaderClass = ABI50_0_0UMProvidedAppLoaderClasses[loaderName];
  return [loaderClass new];
}

# pragma mark - static

+ (nonnull instancetype)sharedInstance
{
  static ABI50_0_0UMAppLoaderProvider *loaderProvider;
  static dispatch_once_t once;

  dispatch_once(&once, ^{
    loaderProvider = [[ABI50_0_0UMAppLoaderProvider alloc] init];
  });
  return loaderProvider;
}

@end
