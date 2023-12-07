/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <tuple>

#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Float.h>
#include <ABI50_0_0React/utils/ABI50_0_0hash_combine.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Generic data structure describes some values associated with *corners*
 * of a rectangle.
 */
template <typename T>
struct RectangleCorners {
  T topLeft{};
  T topRight{};
  T bottomLeft{};
  T bottomRight{};

  bool operator==(const RectangleCorners<T>& rhs) const noexcept {
    return std::tie(
               this->topLeft,
               this->topRight,
               this->bottomLeft,
               this->bottomRight) ==
        std::tie(rhs.topLeft, rhs.topRight, rhs.bottomLeft, rhs.bottomRight);
  }

  bool operator!=(const RectangleCorners<T>& rhs) const noexcept {
    return !(*this == rhs);
  }

  bool isUniform() const noexcept {
    return topLeft == topRight && topLeft == bottomLeft &&
        topLeft == bottomRight;
  }
};

/*
 * CornerInsets
 */
using CornerInsets = RectangleCorners<Float>;

} // namespace ABI50_0_0facebook::ABI50_0_0React

namespace std {

template <typename T>
struct hash<ABI50_0_0facebook::ABI50_0_0React::RectangleCorners<T>> {
  size_t operator()(
      const ABI50_0_0facebook::ABI50_0_0React::RectangleCorners<T>& corners) const noexcept {
    return ABI50_0_0facebook::ABI50_0_0React::hash_combine(
        corners.topLeft,
        corners.bottomLeft,
        corners.topRight,
        corners.bottomRight);
  }
};

} // namespace std
