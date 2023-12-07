/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>

#include <ABI50_0_0ReactCommon/ABI50_0_0RuntimeExecutor.h>
#include <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorFactory.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0EventBeat.h>
#include <ABI50_0_0React/renderer/leakchecker/ABI50_0_0LeakChecker.h>
#include <ABI50_0_0React/renderer/uimanager/ABI50_0_0UIManagerCommitHook.h>
#include <ABI50_0_0React/renderer/uimanager/ABI50_0_0primitives.h>
#include <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>
#include <ABI50_0_0React/utils/ABI50_0_0RunLoopObserver.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Contains all external dependencies of Scheduler.
 * Copyable.
 */
struct SchedulerToolbox final {
  /*
   * Represents general purpose DI container for product components/needs.
   * Must not be `nullptr`.
   */
  ContextContainer::Shared contextContainer;

  /*
   * Represents externally managed, lazily available collection of components.
   */
  ComponentRegistryFactory componentRegistryFactory;

  /*
   * Represents running JavaScript VM and associated execution queue.
   * Can execute lambdas before main bundle has loaded.
   */
  std::optional<RuntimeExecutor> bridgelessBindingsExecutor;

  /*
   * Represents running JavaScript VM and associated execution queue.
   * Executes lambdas after main bundle has loaded.
   */
  RuntimeExecutor runtimeExecutor;

  /*
   * Represent connections with a platform-specific UI run loops.
   */
  RunLoopObserver::Factory mainRunLoopObserverFactory;

  /*
   * Asynchronous & synchronous event beats.
   * Represent connections with the platform-specific run loops and general
   * purpose background queue.
   */
  EventBeat::Factory asynchronousEventBeatFactory;
  EventBeat::Factory synchronousEventBeatFactory;

  /*
   * General-purpose executor that is used to dispatch work on some utility
   * queue (mostly) asynchronously to avoid unnecessary blocking the caller
   * queue.
   * The concrete implementation can use a serial or concurrent queue.
   * Due to architectural constraints, the concrete implementation *must* call
   * the call back synchronously if the executor is invoked on the main thread.
   */
  BackgroundExecutor backgroundExecutor;

  /*
   * A list of `UIManagerCommitHook`s that should be registered in `UIManager`.
   */
  std::vector<std::shared_ptr<UIManagerCommitHook>> commitHooks;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
