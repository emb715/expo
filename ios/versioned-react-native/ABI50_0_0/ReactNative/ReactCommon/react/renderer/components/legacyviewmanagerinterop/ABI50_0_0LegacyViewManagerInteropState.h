/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#import <memory>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * State for <LegacyViewManagerInterop> component.
 */
class LegacyViewManagerInteropState final {
 public:
  std::shared_ptr<void> coordinator;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
