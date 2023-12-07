/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTSurfaceTouchHandler.h"

#import <ABI50_0_0React/ABI50_0_0RCTIdentifierPool.h>
#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewComponentView.h>

#import "ABI50_0_0RCTConversions.h"
#import "ABI50_0_0RCTSurfacePointerHandler.h"
#import "ABI50_0_0RCTTouchableComponentViewProtocol.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

typedef NS_ENUM(NSInteger, ABI50_0_0RCTTouchEventType) {
  ABI50_0_0RCTTouchEventTypeTouchStart,
  ABI50_0_0RCTTouchEventTypeTouchMove,
  ABI50_0_0RCTTouchEventTypeTouchEnd,
  ABI50_0_0RCTTouchEventTypeTouchCancel,
};

struct ActiveTouch {
  Touch touch;
  SharedTouchEventEmitter eventEmitter;

  /*
   * A component view on which the touch was begun.
   */
  __strong UIView<ABI50_0_0RCTComponentViewProtocol> *componentView = nil;

  struct Hasher {
    size_t operator()(const ActiveTouch &activeTouch) const
    {
      return std::hash<decltype(activeTouch.touch.identifier)>()(activeTouch.touch.identifier);
    }
  };

  struct Comparator {
    bool operator()(const ActiveTouch &lhs, const ActiveTouch &rhs) const
    {
      return lhs.touch.identifier == rhs.touch.identifier;
    }
  };
};

static void UpdateActiveTouchWithUITouch(
    ActiveTouch &activeTouch,
    UITouch *uiTouch,
    UIView *rootComponentView,
    CGPoint rootViewOriginOffset)
{
  CGPoint offsetPoint = [uiTouch locationInView:activeTouch.componentView];
  CGPoint pagePoint = [uiTouch locationInView:rootComponentView];
  CGPoint screenPoint = [rootComponentView convertPoint:pagePoint
                                      toCoordinateSpace:rootComponentView.window.screen.coordinateSpace];
  pagePoint = CGPointMake(pagePoint.x + rootViewOriginOffset.x, pagePoint.y + rootViewOriginOffset.y);

  activeTouch.touch.offsetPoint = ABI50_0_0RCTPointFromCGPoint(offsetPoint);
  activeTouch.touch.screenPoint = ABI50_0_0RCTPointFromCGPoint(screenPoint);
  activeTouch.touch.pagePoint = ABI50_0_0RCTPointFromCGPoint(pagePoint);

  activeTouch.touch.timestamp = uiTouch.timestamp;

  if (ABI50_0_0RCTForceTouchAvailable()) {
    activeTouch.touch.force = ABI50_0_0RCTZeroIfNaN(uiTouch.force / uiTouch.maximumPossibleForce);
  }
}

static ActiveTouch CreateTouchWithUITouch(UITouch *uiTouch, UIView *rootComponentView, CGPoint rootViewOriginOffset)
{
  ActiveTouch activeTouch = {};

  // Find closest Fabric-managed touchable view
  UIView *componentView = uiTouch.view;
  while (componentView) {
    if ([componentView respondsToSelector:@selector(touchEventEmitterAtPoint:)]) {
      activeTouch.eventEmitter = [(id<ABI50_0_0RCTTouchableComponentViewProtocol>)componentView
          touchEventEmitterAtPoint:[uiTouch locationInView:componentView]];
      activeTouch.touch.target = (Tag)componentView.tag;
      activeTouch.componentView = componentView;
      break;
    }
    componentView = componentView.superview;
  }

  UpdateActiveTouchWithUITouch(activeTouch, uiTouch, rootComponentView, rootViewOriginOffset);
  return activeTouch;
}

static BOOL AllTouchesAreCancelledOrEnded(NSSet<UITouch *> *touches)
{
  for (UITouch *touch in touches) {
    if (touch.phase == UITouchPhaseBegan || touch.phase == UITouchPhaseMoved || touch.phase == UITouchPhaseStationary) {
      return NO;
    }
  }
  return YES;
}

static BOOL AnyTouchesChanged(NSSet<UITouch *> *touches)
{
  for (UITouch *touch in touches) {
    if (touch.phase == UITouchPhaseBegan || touch.phase == UITouchPhaseMoved) {
      return YES;
    }
  }
  return NO;
}

/**
 * Surprisingly, `__unsafe_unretained id` pointers are not regular pointers
 * and `std::hash<>` cannot hash them.
 * This is quite trivial but decent implementation of hasher function
 * inspired by this research: https://stackoverflow.com/a/21062520/496389.
 */
template <typename PointerT>
struct PointerHasher {
  constexpr std::size_t operator()(const PointerT &value) const
  {
    return reinterpret_cast<size_t>(value);
  }
};

@interface ABI50_0_0RCTSurfaceTouchHandler () <UIGestureRecognizerDelegate>
@end

@implementation ABI50_0_0RCTSurfaceTouchHandler {
  std::unordered_map<__unsafe_unretained UITouch *, ActiveTouch, PointerHasher<__unsafe_unretained UITouch *>>
      _activeTouches;

  /*
   * We hold the view weakly to prevent a retain cycle.
   */
  __weak UIView *_rootComponentView;
  ABI50_0_0RCTIdentifierPool<11> _identifierPool;

  ABI50_0_0RCTSurfacePointerHandler *_pointerHandler;
}

- (instancetype)init
{
  if (self = [super initWithTarget:nil action:nil]) {
    // `cancelsTouchesInView` and `delaysTouches*` are needed in order
    // to be used as a top level event delegated recognizer.
    // Otherwise, lower-level components not built using ABI50_0_0React Native,
    // will fail to recognize gestures.
    self.cancelsTouchesInView = NO;
    self.delaysTouchesBegan = NO; // This is default value.
    self.delaysTouchesEnded = NO;

    self.delegate = self;

    if (ABI50_0_0RCTGetDispatchW3CPointerEvents()) {
      _pointerHandler = [[ABI50_0_0RCTSurfacePointerHandler alloc] init];
    }
  }

  return self;
}

ABI50_0_0RCT_NOT_IMPLEMENTED(-(instancetype)initWithTarget : (id)target action : (SEL)action)

- (void)attachToView:(UIView *)view
{
  ABI50_0_0RCTAssert(self.view == nil, @"ABI50_0_0RCTTouchHandler already has attached view.");

  [view addGestureRecognizer:self];
  _rootComponentView = view;

  if (_pointerHandler != nil) {
    [_pointerHandler attachToView:view];
  }
}

- (void)detachFromView:(UIView *)view
{
  ABI50_0_0RCTAssertParam(view);
  ABI50_0_0RCTAssert(self.view == view, @"ABI50_0_0RCTTouchHandler attached to another view.");

  [view removeGestureRecognizer:self];
  _rootComponentView = nil;

  if (_pointerHandler != nil) {
    [_pointerHandler detachFromView:view];
  }
}

- (void)_registerTouches:(NSSet<UITouch *> *)touches
{
  for (UITouch *touch in touches) {
    auto activeTouch = CreateTouchWithUITouch(touch, _rootComponentView, _viewOriginOffset);
    activeTouch.touch.identifier = _identifierPool.dequeue();
    _activeTouches.emplace(touch, activeTouch);
  }
}

- (void)_updateTouches:(NSSet<UITouch *> *)touches
{
  for (UITouch *touch in touches) {
    auto iterator = _activeTouches.find(touch);
    ABI50_0_0RCTAssert(iterator != _activeTouches.end(), @"Inconsistency between local and UIKit touch registries");
    if (iterator == _activeTouches.end()) {
      continue;
    }

    UpdateActiveTouchWithUITouch(iterator->second, touch, _rootComponentView, _viewOriginOffset);
  }
}

- (void)_unregisterTouches:(NSSet<UITouch *> *)touches
{
  for (UITouch *touch in touches) {
    auto iterator = _activeTouches.find(touch);
    ABI50_0_0RCTAssert(iterator != _activeTouches.end(), @"Inconsistency between local and UIKit touch registries");
    if (iterator == _activeTouches.end()) {
      continue;
    }
    auto &activeTouch = iterator->second;
    _identifierPool.enqueue(activeTouch.touch.identifier);
    _activeTouches.erase(touch);
  }
}

- (std::vector<ActiveTouch>)_activeTouchesFromTouches:(NSSet<UITouch *> *)touches
{
  std::vector<ActiveTouch> activeTouches;
  activeTouches.reserve(touches.count);

  for (UITouch *touch in touches) {
    auto iterator = _activeTouches.find(touch);
    ABI50_0_0RCTAssert(iterator != _activeTouches.end(), @"Inconsistency between local and UIKit touch registries");
    if (iterator == _activeTouches.end()) {
      continue;
    }
    activeTouches.push_back(iterator->second);
  }

  return activeTouches;
}

- (void)_dispatchActiveTouches:(std::vector<ActiveTouch>)activeTouches eventType:(ABI50_0_0RCTTouchEventType)eventType
{
  TouchEvent event = {};
  std::unordered_set<ActiveTouch, ActiveTouch::Hasher, ActiveTouch::Comparator> changedActiveTouches = {};
  std::unordered_set<SharedTouchEventEmitter> uniqueEventEmitters = {};
  BOOL isEndishEventType = eventType == ABI50_0_0RCTTouchEventTypeTouchEnd || eventType == ABI50_0_0RCTTouchEventTypeTouchCancel;

  for (const auto &activeTouch : activeTouches) {
    if (!activeTouch.eventEmitter) {
      continue;
    }

    changedActiveTouches.insert(activeTouch);
    event.changedTouches.insert(activeTouch.touch);
    uniqueEventEmitters.insert(activeTouch.eventEmitter);
  }

  for (const auto &pair : _activeTouches) {
    if (!pair.second.eventEmitter) {
      continue;
    }

    if (isEndishEventType && event.changedTouches.find(pair.second.touch) != event.changedTouches.end()) {
      continue;
    }

    event.touches.insert(pair.second.touch);
  }

  for (const auto &eventEmitter : uniqueEventEmitters) {
    event.targetTouches.clear();

    for (const auto &pair : _activeTouches) {
      if (pair.second.eventEmitter == eventEmitter) {
        event.targetTouches.insert(pair.second.touch);
      }
    }

    switch (eventType) {
      case ABI50_0_0RCTTouchEventTypeTouchStart:
        eventEmitter->onTouchStart(event);
        break;
      case ABI50_0_0RCTTouchEventTypeTouchMove:
        eventEmitter->onTouchMove(event);
        break;
      case ABI50_0_0RCTTouchEventTypeTouchEnd:
        eventEmitter->onTouchEnd(event);
        break;
      case ABI50_0_0RCTTouchEventTypeTouchCancel:
        eventEmitter->onTouchCancel(event);
        break;
    }
  }
}

#pragma mark - `UIResponder`-ish touch-delivery methods

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [super touchesBegan:touches withEvent:event];

  [self _registerTouches:touches];
  [self _dispatchActiveTouches:[self _activeTouchesFromTouches:touches] eventType:ABI50_0_0RCTTouchEventTypeTouchStart];

  if (self.state == UIGestureRecognizerStatePossible) {
    self.state = UIGestureRecognizerStateBegan;
  } else if (self.state == UIGestureRecognizerStateBegan) {
    self.state = UIGestureRecognizerStateChanged;
  }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [super touchesMoved:touches withEvent:event];

  [self _updateTouches:touches];
  [self _dispatchActiveTouches:[self _activeTouchesFromTouches:touches] eventType:ABI50_0_0RCTTouchEventTypeTouchMove];

  self.state = UIGestureRecognizerStateChanged;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [super touchesEnded:touches withEvent:event];

  [self _updateTouches:touches];
  [self _dispatchActiveTouches:[self _activeTouchesFromTouches:touches] eventType:ABI50_0_0RCTTouchEventTypeTouchEnd];
  [self _unregisterTouches:touches];

  if (AllTouchesAreCancelledOrEnded(event.allTouches)) {
    self.state = UIGestureRecognizerStateEnded;
  } else if (AnyTouchesChanged(event.allTouches)) {
    self.state = UIGestureRecognizerStateChanged;
  }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [super touchesCancelled:touches withEvent:event];

  [self _updateTouches:touches];
  [self _dispatchActiveTouches:[self _activeTouchesFromTouches:touches] eventType:ABI50_0_0RCTTouchEventTypeTouchCancel];
  [self _unregisterTouches:touches];

  if (AllTouchesAreCancelledOrEnded(event.allTouches)) {
    self.state = UIGestureRecognizerStateCancelled;
  } else if (AnyTouchesChanged(event.allTouches)) {
    self.state = UIGestureRecognizerStateChanged;
  }
}

- (void)reset
{
  [super reset];

  if (!_activeTouches.empty()) {
    std::vector<ActiveTouch> activeTouches;
    activeTouches.reserve(_activeTouches.size());

    for (const auto &pair : _activeTouches) {
      activeTouches.push_back(pair.second);
    }

    [self _dispatchActiveTouches:activeTouches eventType:ABI50_0_0RCTTouchEventTypeTouchCancel];

    // Force-unregistering all the touches.
    _activeTouches.clear();
    _identifierPool.reset();
  }
}

- (BOOL)canPreventGestureRecognizer:(__unused UIGestureRecognizer *)preventedGestureRecognizer
{
  return NO;
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
  // We fail in favour of other external gesture recognizers.
  // iOS will ask `delegate`'s opinion about this gesture recognizer little bit later.
  return ![preventingGestureRecognizer.view isDescendantOfView:self.view];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(__unused UIGestureRecognizer *)gestureRecognizer
    shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  // Same condition for `failure of` as for `be prevented by`.
  return [self canBePreventedByGestureRecognizer:otherGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  BOOL canBePrevented = [self canBePreventedByGestureRecognizer:otherGestureRecognizer];
  if (canBePrevented) {
    [self _cancelTouches];
  }
  return NO;
}

#pragma mark -

- (void)_cancelTouches
{
  [self setEnabled:NO];
  [self setEnabled:YES];
}

@end
