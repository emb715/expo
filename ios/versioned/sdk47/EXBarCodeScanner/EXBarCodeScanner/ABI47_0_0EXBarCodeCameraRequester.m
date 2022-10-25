// Copyright 2016-present 650 Industries. All rights reserved.

#import <ABI47_0_0EXBarCodeScanner/ABI47_0_0EXBarCodeCameraRequester.h>
#import <ABI47_0_0ExpoModulesCore/ABI47_0_0EXDefines.h>
#import <ABI47_0_0ExpoModulesCore/ABI47_0_0EXPermissionsInterface.h>

#import <AVFoundation/AVFoundation.h>


@implementation ABI47_0_0EXBareCodeCameraRequester

+ (NSString *)permissionType {
  return @"camera";
}

- (NSDictionary *)getPermissions
{
  AVAuthorizationStatus systemStatus;
  ABI47_0_0EXPermissionStatus status;
  NSString *cameraUsageDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSCameraUsageDescription"];
  if (!cameraUsageDescription) {
    ABI47_0_0EXFatal(ABI47_0_0EXErrorWithMessage(@"This app is missing 'NSCameraUsageDescription', so video services will fail. Add this entry to your bundle's Info.plist."));
    systemStatus = AVAuthorizationStatusDenied;
  } else {
    systemStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
  }
  switch (systemStatus) {
    case AVAuthorizationStatusAuthorized:
      status = ABI47_0_0EXPermissionStatusGranted;
      break;
    case AVAuthorizationStatusDenied:
    case AVAuthorizationStatusRestricted:
      status = ABI47_0_0EXPermissionStatusDenied;
      break;
    case AVAuthorizationStatusNotDetermined:
      status = ABI47_0_0EXPermissionStatusUndetermined;
      break;
  }
  return @{
    @"status": @(status)
  };
}

- (void)requestPermissionsWithResolver:(ABI47_0_0EXPromiseResolveBlock)resolve rejecter:(ABI47_0_0EXPromiseRejectBlock)reject
{
  ABI47_0_0EX_WEAKIFY(self)
  [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
    ABI47_0_0EX_STRONGIFY(self)
    resolve([self getPermissions]);
  }];
}

@end
