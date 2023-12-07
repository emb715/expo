/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

// @generated by enums.py
// clang-format off
#pragma once

#include <cstdint>
#include <ABI50_0_0yoga/ABI50_0_0YGEnums.h>
#include <ABI50_0_0yoga/enums/ABI50_0_0YogaEnums.h>

namespace ABI50_0_0facebook::yoga {

enum class PrintOptions : uint32_t {
  Layout = ABI50_0_0YGPrintOptionsLayout,
  Style = ABI50_0_0YGPrintOptionsStyle,
  Children = ABI50_0_0YGPrintOptionsChildren,
};

ABI50_0_0YG_DEFINE_ENUM_FLAG_OPERATORS(PrintOptions)

template <>
constexpr inline int32_t ordinalCount<PrintOptions>() {
  return 3;
} 

template <>
constexpr inline int32_t bitCount<PrintOptions>() {
  return 2;
} 

constexpr inline PrintOptions scopedEnum(ABI50_0_0YGPrintOptions unscoped) {
  return static_cast<PrintOptions>(unscoped);
}

constexpr inline ABI50_0_0YGPrintOptions unscopedEnum(PrintOptions scoped) {
  return static_cast<ABI50_0_0YGPrintOptions>(scoped);
}

inline const char* toString(PrintOptions e) {
  return ABI50_0_0YGPrintOptionsToString(unscopedEnum(e));
}

} // namespace ABI50_0_0facebook::yoga
