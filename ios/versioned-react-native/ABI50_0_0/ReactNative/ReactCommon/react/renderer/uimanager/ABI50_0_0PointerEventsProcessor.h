/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <functional>

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <ABI50_0_0React/renderer/uimanager/ABI50_0_0UIManager.h>
#include <ABI50_0_0React/renderer/uimanager/ABI50_0_0primitives.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

// Helper struct to package a PointerEvent and SharedEventTarget together
struct PointerEventTarget {
  PointerEvent event;
  SharedEventTarget target;
};

// Helper struct to contain an active pointer's event data along with additional
// metadata
struct ActivePointer {
  PointerEvent event;
};

using DispatchEvent = std::function<void(
    jsi::Runtime& runtime,
    const EventTarget* eventTarget,
    const std::string& type,
    ABI50_0_0ReactEventPriority priority,
    const EventPayload& payload)>;

using PointerIdentifier = int32_t;
using CaptureTargetOverrideRegistry =
    std::unordered_map<PointerIdentifier, ShadowNode::Weak>;

using ActivePointerRegistry =
    std::unordered_map<PointerIdentifier, ActivePointer>;

class PointerEventsProcessor final {
 public:
  void interceptPointerEvent(
      jsi::Runtime& runtime,
      const EventTarget* eventTarget,
      const std::string& type,
      ABI50_0_0ReactEventPriority priority,
      const PointerEvent& event,
      const DispatchEvent& eventDispatcher,
      const UIManager& uiManager);

  void setPointerCapture(
      PointerIdentifier pointerId,
      const ShadowNode::Shared& shadowNode);
  void releasePointerCapture(
      PointerIdentifier pointerId,
      const ShadowNode* shadowNode);
  bool hasPointerCapture(
      PointerIdentifier pointerId,
      const ShadowNode* shadowNode);

 private:
  ActivePointer* getActivePointer(PointerIdentifier pointerId);

  void registerActivePointer(const PointerEvent& event);
  void updateActivePointer(const PointerEvent& event);
  void unregisterActivePointer(const PointerEvent& event);

  void processPendingPointerCapture(
      const PointerEvent& event,
      jsi::Runtime& runtime,
      const DispatchEvent& eventDispatcher,
      const UIManager& uiManager);

  ActivePointerRegistry activePointers_;

  CaptureTargetOverrideRegistry pendingPointerCaptureTargetOverrides_;
  CaptureTargetOverrideRegistry activePointerCaptureTargetOverrides_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
