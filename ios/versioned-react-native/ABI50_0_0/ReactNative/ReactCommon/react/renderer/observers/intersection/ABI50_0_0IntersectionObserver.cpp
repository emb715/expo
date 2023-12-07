/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0IntersectionObserver.h"
#include <ABI50_0_0React/debug/ABI50_0_0React_native_assert.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutMetrics.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutableShadowNode.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNodeFamily.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0TraitCast.h>
#include <utility>

namespace ABI50_0_0facebook::ABI50_0_0React {

IntersectionObserver::IntersectionObserver(
    IntersectionObserverObserverId intersectionObserverId,
    ShadowNode::Shared targetShadowNode,
    std::vector<Float> thresholds)
    : intersectionObserverId_(intersectionObserverId),
      targetShadowNode_(std::move(targetShadowNode)),
      thresholds_(std::move(thresholds)) {}

static Rect getRootBoundingRect(
    const LayoutableShadowNode& layoutableRootShadowNode) {
  auto layoutMetrics = layoutableRootShadowNode.getLayoutMetrics();

  if (layoutMetrics == EmptyLayoutMetrics ||
      layoutMetrics.displayType == DisplayType::None) {
    return Rect{};
  }

  // Apply the transform to translate the root view to its location in the
  // viewport.
  return layoutMetrics.frame * layoutableRootShadowNode.getTransform();
}

static Rect getTargetBoundingRect(
    const ShadowNodeFamily::AncestorList& targetAncestors) {
  auto layoutMetrics = LayoutableShadowNode::computeRelativeLayoutMetrics(
      targetAncestors,
      {/* .includeTransform = */ true,
       /* .includeViewportOffset = */ true});
  return layoutMetrics == EmptyLayoutMetrics ? Rect{} : layoutMetrics.frame;
}

static Rect getClippedTargetBoundingRect(
    const ShadowNodeFamily::AncestorList& targetAncestors) {
  auto layoutMetrics = LayoutableShadowNode::computeRelativeLayoutMetrics(
      targetAncestors,
      {/* .includeTransform = */ true,
       /* .includeViewportOffset = */ true,
       /* .applyParentClipping = */ true});

  return layoutMetrics == EmptyLayoutMetrics ? Rect{} : layoutMetrics.frame;
}

// Partially equivalent to
// https://w3c.github.io/IntersectionObserver/#compute-the-intersection
static Rect computeIntersection(
    const Rect& rootBoundingRect,
    const Rect& targetBoundingRect,
    const ShadowNodeFamily::AncestorList& targetAncestors) {
  auto absoluteIntersectionRect =
      Rect::intersect(rootBoundingRect, targetBoundingRect);

  Float absoluteIntersectionRectArea = absoluteIntersectionRect.size.width *
      absoluteIntersectionRect.size.height;

  Float targetBoundingRectArea =
      targetBoundingRect.size.width * targetBoundingRect.size.height;

  // Finish early if there is not intersection between the root and the target
  // before we do any clipping.
  if (absoluteIntersectionRectArea == 0 || targetBoundingRectArea == 0) {
    return {};
  }

  // Coordinates of the target after clipping the parts hidden by a parent
  // (e.g.: in scroll views, or in views with a parent with overflow: hidden)
  auto clippedTargetBoundingRect =
      getClippedTargetBoundingRect(targetAncestors);

  return Rect::intersect(rootBoundingRect, clippedTargetBoundingRect);
}

// Partially equivalent to
// https://w3c.github.io/IntersectionObserver/#update-intersection-observations-algo
std::optional<IntersectionObserverEntry>
IntersectionObserver::updateIntersectionObservation(
    const RootShadowNode& rootShadowNode,
    double mountTime) {
  const auto layoutableRootShadowNode =
      traitCast<const LayoutableShadowNode*>(&rootShadowNode);

  ABI50_0_0React_native_assert(
      layoutableRootShadowNode != nullptr &&
      "RootShadowNode instances must always inherit from LayoutableShadowNode.");

  auto targetAncestors =
      targetShadowNode_->getFamily().getAncestors(rootShadowNode);

  // Absolute coordinates of the root
  auto rootBoundingRect = getRootBoundingRect(*layoutableRootShadowNode);

  // Absolute coordinates of the target
  auto targetBoundingRect = getTargetBoundingRect(targetAncestors);

  auto intersectionRect = computeIntersection(
      rootBoundingRect, targetBoundingRect, targetAncestors);

  Float targetBoundingRectArea =
      targetBoundingRect.size.width * targetBoundingRect.size.height;
  auto intersectionRectArea =
      intersectionRect.size.width * intersectionRect.size.height;

  Float intersectionRatio =
      targetBoundingRectArea == 0 // prevent division by zero
      ? 0
      : intersectionRectArea / targetBoundingRectArea;

  if (intersectionRatio == 0) {
    return setNotIntersectingState(
        rootBoundingRect, targetBoundingRect, mountTime);
  }

  auto highestThresholdCrossed = getHighestThresholdCrossed(intersectionRatio);
  if (highestThresholdCrossed == -1) {
    return setNotIntersectingState(
        rootBoundingRect, targetBoundingRect, mountTime);
  }

  return setIntersectingState(
      rootBoundingRect,
      targetBoundingRect,
      intersectionRect,
      highestThresholdCrossed,
      mountTime);
}

Float IntersectionObserver::getHighestThresholdCrossed(
    Float intersectionRatio) {
  Float highestThreshold = -1;
  for (auto threshold : thresholds_) {
    if (intersectionRatio >= threshold) {
      highestThreshold = threshold;
    }
  }
  return highestThreshold;
}

std::optional<IntersectionObserverEntry>
IntersectionObserver::setIntersectingState(
    const Rect& rootBoundingRect,
    const Rect& targetBoundingRect,
    const Rect& intersectionRect,
    Float threshold,
    double mountTime) {
  auto newState = IntersectionObserverState::Intersecting(threshold);

  if (state_ != newState) {
    state_ = newState;
    IntersectionObserverEntry entry{
        intersectionObserverId_,
        targetShadowNode_,
        targetBoundingRect,
        rootBoundingRect,
        intersectionRect,
        true,
        mountTime,
    };
    return std::optional<IntersectionObserverEntry>{std::move(entry)};
  }

  return std::nullopt;
}

std::optional<IntersectionObserverEntry>
IntersectionObserver::setNotIntersectingState(
    const Rect& rootBoundingRect,
    const Rect& targetBoundingRect,
    double mountTime) {
  if (state_ != IntersectionObserverState::NotIntersecting()) {
    state_ = IntersectionObserverState::NotIntersecting();
    IntersectionObserverEntry entry{
        intersectionObserverId_,
        targetShadowNode_,
        targetBoundingRect,
        rootBoundingRect,
        std::nullopt,
        false,
        mountTime,
    };
    return std::optional<IntersectionObserverEntry>(std::move(entry));
  }

  return std::nullopt;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
