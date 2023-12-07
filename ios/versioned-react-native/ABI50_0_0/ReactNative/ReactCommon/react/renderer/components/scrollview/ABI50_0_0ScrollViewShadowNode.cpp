/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0ScrollViewShadowNode.h"

#include <ABI50_0_0React/debug/ABI50_0_0React_native_assert.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutMetrics.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

const char ScrollViewComponentName[] = "ScrollView";

void ScrollViewShadowNode::updateStateIfNeeded() {
  ensureUnsealed();

  auto contentBoundingRect = Rect{};
  for (const auto& childNode : getLayoutableChildNodes()) {
    contentBoundingRect.unionInPlace(childNode->getLayoutMetrics().frame);
  }

  auto state = getStateData();

  if (state.contentBoundingRect != contentBoundingRect) {
    state.contentBoundingRect = contentBoundingRect;
    setStateData(std::move(state));
  }
}

void ScrollViewShadowNode::updateScrollContentOffsetIfNeeded() {
#ifndef ANDROID
  if (getLayoutMetrics().layoutDirection == LayoutDirection::RightToLeft) {
    // Yoga places `contentView` on the right side of `scrollView` when RTL
    // layout is enforced. To correct for this, in RTL setting, correct the
    // frame's origin. ABI50_0_0React Native Classic does this as well in
    // `ABI50_0_0RCTScrollContentShadowView.m`.
    for (auto layoutableNode : getLayoutableChildNodes()) {
      auto layoutMetrics = layoutableNode->getLayoutMetrics();
      if (layoutMetrics.frame.origin.x != 0) {
        layoutMetrics.frame.origin.x = 0;
        layoutableNode->setLayoutMetrics(layoutMetrics);
      }
    }
  }
#endif
}

ScrollViewState ScrollViewShadowNode::initialStateData(
    const Props::Shared& props,
    const ShadowNodeFamily::Shared& /*family*/,
    const ComponentDescriptor& /*componentDescriptor*/) {
  return {static_cast<const ScrollViewProps&>(*props).contentOffset, {}, 0};
}

#pragma mark - LayoutableShadowNode

void ScrollViewShadowNode::layout(LayoutContext layoutContext) {
  ConcreteViewShadowNode::layout(layoutContext);
  updateScrollContentOffsetIfNeeded();
  updateStateIfNeeded();
}

Point ScrollViewShadowNode::getContentOriginOffset() const {
  auto stateData = getStateData();
  auto contentOffset = stateData.contentOffset;
  return {-contentOffset.x, -contentOffset.y + stateData.scrollAwayPaddingTop};
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
