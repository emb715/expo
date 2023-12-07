/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <functional>
#include <memory>

#include "ABI50_0_0SchedulerPriority.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

using CallFunc = std::function<void()>;

/**
 * An interface for a generic native-to-JS call invoker. See BridgeJSCallInvoker
 * for an implementation.
 */
class CallInvoker {
 public:
  virtual void invokeAsync(CallFunc&& func) = 0;
  virtual void invokeAsync(SchedulerPriority /*priority*/, CallFunc&& func) {
    // When call with priority is not implemented, fall back to a regular async
    // execution
    invokeAsync(std::move(func));
  }
  virtual void invokeSync(CallFunc&& func) = 0;
  virtual ~CallInvoker() {}
};

class NativeMethodCallInvoker {
 public:
  virtual void invokeAsync(const std::string& methodName, CallFunc&& func) = 0;
  virtual void invokeSync(const std::string& methodName, CallFunc&& func) = 0;
  virtual ~NativeMethodCallInvoker() {}
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
