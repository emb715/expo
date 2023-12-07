// Copyright 2017-present 650 Industries. All rights reserved.

#import <ABI50_0_0EXMediaLibrary/ABI50_0_0EXMediaLibraryMediaLibraryWriteOnlyPermissionRequester.h>

@implementation ABI50_0_0EXMediaLibraryMediaLibraryWriteOnlyPermissionRequester

+ (NSString *)permissionType
{
  return @"mediaLibraryWriteOnly";
}

#ifdef __IPHONE_14_0
- (PHAccessLevel)accessLevel API_AVAILABLE(ios(14))
{
  return PHAccessLevelAddOnly;
}
#endif

@end
