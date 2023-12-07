/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/view/ABI50_0_0HostPlatformViewEventEmitter.h>

namespace ABI50_0_0facebook::ABI50_0_0React {
using ViewEventEmitter = HostPlatformViewEventEmitter;
using SharedViewEventEmitter = std::shared_ptr<const ViewEventEmitter>;
} // namespace ABI50_0_0facebook::ABI50_0_0React
