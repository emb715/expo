/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0JSCExecutorFactory.h"

#import <jsc/ABI50_0_0JSCRuntime.h>

#import <memory>

namespace ABI50_0_0facebook::ABI50_0_0React {

std::unique_ptr<JSExecutor> JSCExecutorFactory::createJSExecutor(
    std::shared_ptr<ExecutorDelegate> delegate,
    std::shared_ptr<MessageQueueThread> __unused jsQueue)
{
  return std::make_unique<JSIExecutor>(
      ABI50_0_0facebook::jsc::makeJSCRuntime(), delegate, JSIExecutor::defaultTimeoutInvoker, runtimeInstaller_);
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
