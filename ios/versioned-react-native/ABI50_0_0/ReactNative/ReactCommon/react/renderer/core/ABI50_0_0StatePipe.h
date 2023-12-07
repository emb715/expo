/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <functional>

#include <ABI50_0_0React/renderer/core/ABI50_0_0StateUpdate.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

using StatePipe = std::function<void(const StateUpdate& stateUpdate)>;

} // namespace ABI50_0_0facebook::ABI50_0_0React
