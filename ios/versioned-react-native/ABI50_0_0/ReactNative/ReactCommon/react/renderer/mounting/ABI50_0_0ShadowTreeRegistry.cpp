/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0ShadowTreeRegistry.h"

#include <ABI50_0_0React/debug/ABI50_0_0React_native_assert.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

ShadowTreeRegistry::~ShadowTreeRegistry() {
  ABI50_0_0React_native_assert(
      registry_.empty() && "Deallocation of non-empty `ShadowTreeRegistry`.");
}

void ShadowTreeRegistry::add(std::unique_ptr<ShadowTree>&& shadowTree) const {
  std::unique_lock lock(mutex_);

  registry_.emplace(shadowTree->getSurfaceId(), std::move(shadowTree));
}

std::unique_ptr<ShadowTree> ShadowTreeRegistry::remove(
    SurfaceId surfaceId) const {
  std::unique_lock lock(mutex_);

  auto iterator = registry_.find(surfaceId);
  if (iterator == registry_.end()) {
    return {};
  }

  auto shadowTree = std::unique_ptr<ShadowTree>(iterator->second.release());
  registry_.erase(iterator);
  return shadowTree;
}

bool ShadowTreeRegistry::visit(
    SurfaceId surfaceId,
    const std::function<void(const ShadowTree& shadowTree)>& callback) const {
  std::shared_lock lock(mutex_);

  auto iterator = registry_.find(surfaceId);

  if (iterator == registry_.end()) {
    return false;
  }

  callback(*iterator->second);
  return true;
}

void ShadowTreeRegistry::enumerate(
    const std::function<void(const ShadowTree& shadowTree, bool& stop)>&
        callback) const {
  std::shared_lock lock(mutex_);
  auto stop = false;
  for (const auto& pair : registry_) {
    callback(*pair.second, stop);
    if (stop) {
      return;
    }
  }
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
