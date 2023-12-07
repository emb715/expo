/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0ReactCommon/ABI50_0_0CallInvoker.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class RuntimeScheduler;
/*
 * Exposes RuntimeScheduler to native modules. All calls invoked on JavaScript
 * queue from native modules will be funneled through RuntimeScheduler.
 */
class RuntimeSchedulerCallInvoker : public CallInvoker {
 public:
  RuntimeSchedulerCallInvoker(std::weak_ptr<RuntimeScheduler> runtimeScheduler);

  void invokeAsync(CallFunc&& func) override;
  void invokeSync(CallFunc&& func) override;
  void invokeAsync(SchedulerPriority priority, CallFunc&& func) override;

 private:
  /*
   * RuntimeScheduler is retained by the runtime. It must not be
   * retained by anything beyond the runtime.
   */
  std::weak_ptr<RuntimeScheduler> runtimeScheduler_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
