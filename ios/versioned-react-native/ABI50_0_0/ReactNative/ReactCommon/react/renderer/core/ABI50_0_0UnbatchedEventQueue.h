/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/core/ABI50_0_0EventQueue.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Event Queue that dispatches events as granular as possible without waiting
 * for the next beat.
 */
class UnbatchedEventQueue final : public EventQueue {
 public:
  using EventQueue::EventQueue;

  void onEnqueue() const override;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
