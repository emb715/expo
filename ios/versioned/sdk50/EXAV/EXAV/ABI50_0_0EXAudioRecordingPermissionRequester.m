// Copyright 2016-present 650 Industries. All rights reserved.

#import <ABI50_0_0EXAV/ABI50_0_0EXAudioRecordingPermissionRequester.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXDefines.h>

#import <AVFoundation/AVFoundation.h>

@implementation ABI50_0_0EXAudioRecordingPermissionRequester

+ (NSString *)permissionType
{
  return @"audioRecording";
}

- (NSDictionary *)getPermissions
{
  AVAudioSessionRecordPermission systemStatus;
  ABI50_0_0EXPermissionStatus status;

  NSString *microphoneUsageDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSMicrophoneUsageDescription"];
  if (!microphoneUsageDescription) {
    ABI50_0_0EXFatal(ABI50_0_0EXErrorWithMessage(@"This app is missing NSMicrophoneUsageDescription, so audio services will fail. Add one of these keys to your bundle's Info.plist."));
    systemStatus = AVAudioSessionRecordPermissionDenied;
  } else {
    systemStatus = [[AVAudioSession sharedInstance] recordPermission];
  }
  switch (systemStatus) {
    case AVAudioSessionRecordPermissionGranted:
      status = ABI50_0_0EXPermissionStatusGranted;
      break;
    case AVAudioSessionRecordPermissionDenied:
      status = ABI50_0_0EXPermissionStatusDenied;
      break;
    case AVAudioSessionRecordPermissionUndetermined:
      status = ABI50_0_0EXPermissionStatusUndetermined;
      break;
  }

  return @{
    @"status": @(status)
  };
}

- (void)requestPermissionsWithResolver:(ABI50_0_0EXPromiseResolveBlock)resolve rejecter:(ABI50_0_0EXPromiseRejectBlock)reject
{
  ABI50_0_0EX_WEAKIFY(self)
  [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
    ABI50_0_0EX_STRONGIFY(self)
    resolve([self getPermissions]);
  }];
}

@end
