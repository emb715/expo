/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0BatchedEventQueue.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

BatchedEventQueue::BatchedEventQueue(
    EventQueueProcessor eventProcessor,
    std::unique_ptr<EventBeat> eventBeat)
    : EventQueue(std::move(eventProcessor), std::move(eventBeat)) {}

void BatchedEventQueue::onEnqueue() const {
  eventBeat_->request();
}
} // namespace ABI50_0_0facebook::ABI50_0_0React
