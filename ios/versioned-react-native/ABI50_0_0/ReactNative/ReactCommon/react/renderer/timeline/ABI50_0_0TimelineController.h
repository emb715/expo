/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>
#include <shared_mutex>
#include <unordered_map>

#include <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>
#include <ABI50_0_0React/renderer/timeline/ABI50_0_0Timeline.h>
#include <ABI50_0_0React/renderer/timeline/ABI50_0_0TimelineHandler.h>
#include <ABI50_0_0React/renderer/uimanager/ABI50_0_0UIManagerCommitHook.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Provides tools for introspecting the series of commits and associated
 * side-effects, allowing to "rewind" UI to any particular commit from the past.
 */
class TimelineController final : public UIManagerCommitHook {
 public:
  using Shared = std::shared_ptr<const TimelineController>;

  /*
   * Creates a `TimelineHandler` associated with given `SurfaceId` and starts
   * the introspection process.
   */
  TimelineHandler enable(SurfaceId surfaceId) const;

  /*
   * Consumes and destroys a `TimelineHandler` instance triggering the
   * destruction of all associated resources and stopping the introspection
   * process.
   */
  void disable(TimelineHandler&& handler) const;

  /*
   * TO BE DELETED.
   */
  SurfaceId lastUpdatedSurface() const {
    return lastUpdatedSurface_;
  }

#pragma mark - UIManagerCommitHook

  RootShadowNode::Unshared shadowTreeWillCommit(
      const ShadowTree& shadowTree,
      const RootShadowNode::Shared& oldRootShadowNode,
      const RootShadowNode::Unshared& newRootShadowNode) noexcept override;

  void commitHookWasRegistered(const UIManager& uiManager) noexcept override;

  void commitHookWasUnregistered(const UIManager& uiManager) noexcept override;

 private:
  /*
   * Protects all the data members.
   */
  mutable std::shared_mutex timelinesMutex_;

  /*
   * Owning collection of all running `Timeline` instances.
   */
  mutable std::unordered_map<SurfaceId, std::unique_ptr<Timeline>> timelines_;

  mutable const UIManager* uiManager_;
  mutable SurfaceId lastUpdatedSurface_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
