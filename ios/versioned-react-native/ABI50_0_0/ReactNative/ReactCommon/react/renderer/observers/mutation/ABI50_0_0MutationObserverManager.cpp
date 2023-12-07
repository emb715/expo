/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0MutationObserverManager.h"
#include <ABI50_0_0React/renderer/debug/ABI50_0_0SystraceSection.h>
#include <utility>
#include "ABI50_0_0MutationObserver.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

MutationObserverManager::MutationObserverManager() = default;

void MutationObserverManager::observe(
    MutationObserverId mutationObserverId,
    ShadowNode::Shared shadowNode,
    bool observeSubtree,
    const UIManager& uiManager) {
  SystraceSection s("MutationObserverManager::observe");

  auto surfaceId = shadowNode->getSurfaceId();

  auto& observers = observersBySurfaceId_[surfaceId];

  auto observerIt = observers.find(mutationObserverId);
  if (observerIt == observers.end()) {
    auto observer = MutationObserver{mutationObserverId};
    observer.observe(shadowNode, observeSubtree);
    observers.insert({mutationObserverId, std::move(observer)});
  } else {
    auto observer = observerIt->second;
    observer.observe(shadowNode, observeSubtree);
  }
}

void MutationObserverManager::unobserve(
    MutationObserverId mutationObserverId,
    const ShadowNode& shadowNode) {
  SystraceSection s("MutationObserverManager::unobserve");

  auto surfaceId = shadowNode.getSurfaceId();

  auto observersIt = observersBySurfaceId_.find(surfaceId);
  if (observersIt == observersBySurfaceId_.end()) {
    return;
  }

  auto& observers = observersIt->second;

  auto observerIt = observers.find(mutationObserverId);
  if (observerIt == observers.end()) {
    return;
  }

  auto& observer = observerIt->second;

  observer.unobserve(shadowNode);

  if (!observer.isObserving()) {
    observers.erase(mutationObserverId);
  }

  if (observers.empty()) {
    observersBySurfaceId_.erase(surfaceId);
  }
}

void MutationObserverManager::connect(
    UIManager& uiManager,
    std::function<void(std::vector<const MutationRecord>&)> onMutations) {
  SystraceSection s("MutationObserverManager::connect");

  // Fail-safe in case the caller doesn't guarantee consistency.
  if (commitHookRegistered_) {
    return;
  }

  onMutations_ = onMutations;

  uiManager.registerCommitHook(*this);
  commitHookRegistered_ = true;
}

void MutationObserverManager::disconnect(UIManager& uiManager) {
  SystraceSection s("MutationObserverManager::disconnect");

  // Fail-safe in case the caller doesn't guarantee consistency.
  if (!commitHookRegistered_) {
    return;
  }

  uiManager.unregisterCommitHook(*this);

  onMutations_ = nullptr;
  commitHookRegistered_ = false;
}

void MutationObserverManager::commitHookWasRegistered(
    const UIManager& uiManager) noexcept {}
void MutationObserverManager::commitHookWasUnregistered(
    const UIManager& uiManager) noexcept {}

RootShadowNode::Unshared MutationObserverManager::shadowTreeWillCommit(
    const ShadowTree& shadowTree,
    const RootShadowNode::Shared& oldRootShadowNode,
    const RootShadowNode::Unshared& newRootShadowNode) noexcept {
  runMutationObservations(shadowTree, *oldRootShadowNode, *newRootShadowNode);
  return newRootShadowNode;
}

void MutationObserverManager::runMutationObservations(
    const ShadowTree& shadowTree,
    const RootShadowNode& oldRootShadowNode,
    const RootShadowNode& newRootShadowNode) {
  SystraceSection s("MutationObserverManager::runMutationObservations");

  auto surfaceId = shadowTree.getSurfaceId();

  auto observersIt = observersBySurfaceId_.find(surfaceId);
  if (observersIt == observersBySurfaceId_.end()) {
    return;
  }

  std::vector<const MutationRecord> mutationRecords;

  auto& observers = observersIt->second;
  for (const auto& [mutationObserverId, observer] : observers) {
    observer.recordMutations(
        oldRootShadowNode, newRootShadowNode, mutationRecords);
  }

  if (!mutationRecords.empty()) {
    onMutations_(mutationRecords);
  }

  return;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
