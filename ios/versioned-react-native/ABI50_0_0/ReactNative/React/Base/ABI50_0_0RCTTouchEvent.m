/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTTouchEvent.h"

#import "ABI50_0_0RCTAssert.h"

@implementation ABI50_0_0RCTTouchEvent {
  NSArray<NSDictionary *> *_ABI50_0_0ReactTouches;
  NSArray<NSNumber *> *_changedIndexes;
  uint16_t _coalescingKey;
}

@synthesize eventName = _eventName;
@synthesize viewTag = _viewTag;

- (instancetype)initWithEventName:(NSString *)eventName
                         ABI50_0_0ReactTag:(NSNumber *)ABI50_0_0ReactTag
                     ABI50_0_0ReactTouches:(NSArray<NSDictionary *> *)ABI50_0_0ReactTouches
                   changedIndexes:(NSArray<NSNumber *> *)changedIndexes
                    coalescingKey:(uint16_t)coalescingKey
{
  if (self = [super init]) {
    _viewTag = ABI50_0_0ReactTag;
    _eventName = eventName;
    _ABI50_0_0ReactTouches = ABI50_0_0ReactTouches;
    _changedIndexes = changedIndexes;
    _coalescingKey = coalescingKey;
  }
  return self;
}

ABI50_0_0RCT_NOT_IMPLEMENTED(-(instancetype)init)

#pragma mark - ABI50_0_0RCTEvent

- (BOOL)canCoalesce
{
  return [_eventName isEqual:@"touchMove"];
}

// We coalesce only move events, while holding some assumptions that seem reasonable but there are no explicit
// guarantees about them.
- (id<ABI50_0_0RCTEvent>)coalesceWithEvent:(id<ABI50_0_0RCTEvent>)newEvent
{
  ABI50_0_0RCTAssert(
      [newEvent isKindOfClass:[ABI50_0_0RCTTouchEvent class]],
      @"Touch event cannot be coalesced with any other type of event, such as provided %@",
      newEvent);
  ABI50_0_0RCTTouchEvent *newTouchEvent = (ABI50_0_0RCTTouchEvent *)newEvent;
  ABI50_0_0RCTAssert(
      [_ABI50_0_0ReactTouches count] == [newTouchEvent->_ABI50_0_0ReactTouches count],
      @"Touch events have different number of touches. %@ %@",
      self,
      newEvent);

  BOOL newEventIsMoreRecent = NO;
  BOOL oldEventIsMoreRecent = NO;
  NSInteger count = _ABI50_0_0ReactTouches.count;
  for (int i = 0; i < count; i++) {
    NSDictionary *touch = _ABI50_0_0ReactTouches[i];
    NSDictionary *newTouch = newTouchEvent->_ABI50_0_0ReactTouches[i];
    ABI50_0_0RCTAssert(
        [touch[@"identifier"] isEqual:newTouch[@"identifier"]],
        @"Touch events doesn't have touches in the same order. %@ %@",
        touch,
        newTouch);
    if ([touch[@"timestamp"] doubleValue] > [newTouch[@"timestamp"] doubleValue]) {
      oldEventIsMoreRecent = YES;
    } else {
      newEventIsMoreRecent = YES;
    }
  }
  ABI50_0_0RCTAssert(
      !(oldEventIsMoreRecent && newEventIsMoreRecent),
      @"Neither touch event is exclusively more recent than the other one. %@ %@",
      _ABI50_0_0ReactTouches,
      newTouchEvent->_ABI50_0_0ReactTouches);
  return newEventIsMoreRecent ? newEvent : self;
}

+ (NSString *)moduleDotMethod
{
  return @"ABI50_0_0RCTEventEmitter.receiveTouches";
}

- (NSArray *)arguments
{
  return @[ ABI50_0_0RCTNormalizeInputEventName(_eventName), _ABI50_0_0ReactTouches, _changedIndexes ];
}

- (uint16_t)coalescingKey
{
  return _coalescingKey;
}

- (NSString *)description
{
  return [NSString
      stringWithFormat:@"<%@: %p; name = %@; coalescing key = %hu>", [self class], self, _eventName, _coalescingKey];
}

@end
