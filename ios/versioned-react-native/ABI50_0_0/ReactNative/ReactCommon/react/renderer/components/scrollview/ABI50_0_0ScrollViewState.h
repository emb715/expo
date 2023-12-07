/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Float.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Point.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Rect.h>
#include <ABI50_0_0React/renderer/graphics/ABI50_0_0Size.h>

#ifdef ANDROID
#include <folly/dynamic.h>
#include <ABI50_0_0React/renderer/mapbuffer/ABI50_0_0MapBuffer.h>
#include <ABI50_0_0React/renderer/mapbuffer/ABI50_0_0MapBufferBuilder.h>
#endif

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * State for <ScrollView> component.
 */
class ScrollViewState final {
 public:
  ScrollViewState(
      Point contentOffset,
      Rect contentBoundingRect,
      int scrollAwayPaddingTop);
  ScrollViewState() = default;

  Point contentOffset;
  Rect contentBoundingRect;
  int scrollAwayPaddingTop;

  /*
   * Returns size of scrollable area.
   */
  Size getContentSize() const;

#ifdef ANDROID
  ScrollViewState(const ScrollViewState& previousState, folly::dynamic data)
      : contentOffset(
            {(Float)data["contentOffsetLeft"].getDouble(),
             (Float)data["contentOffsetTop"].getDouble()}),
        contentBoundingRect({}),
        scrollAwayPaddingTop((Float)data["scrollAwayPaddingTop"].getDouble()){};

  folly::dynamic getDynamic() const {
    return folly::dynamic::object("contentOffsetLeft", contentOffset.x)(
        "contentOffsetTop", contentOffset.y)(
        "scrollAwayPaddingTop", scrollAwayPaddingTop);
  };
  MapBuffer getMapBuffer() const {
    return MapBufferBuilder::EMPTY();
  };
#endif
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
