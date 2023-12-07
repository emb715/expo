/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0Props.h"

#include <folly/dynamic.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0propsConversions.h>
#include <ABI50_0_0React/utils/ABI50_0_0CoreFeatures.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

Props::Props(
    const PropsParserContext& context,
    const Props& sourceProps,
    const RawProps& rawProps) {
  initialize(context, sourceProps, rawProps);
}

void Props::initialize(
    const PropsParserContext& context,
    const Props& sourceProps,
    const RawProps& rawProps) {
  nativeId = CoreFeatures::enablePropIteratorSetter
      ? sourceProps.nativeId
      : convertRawProp(context, rawProps, "nativeID", sourceProps.nativeId, {});
#ifdef ANDROID
  this->rawProps = (folly::dynamic)rawProps;
#endif
}

void Props::setProp(
    const PropsParserContext& context,
    RawPropsPropNameHash hash,
    const char* /*propName*/,
    const RawValue& value) {
  switch (hash) {
    case CONSTEXPR_RAW_PROPS_KEY_HASH("nativeID"):
      fromRawValue(context, value, nativeId, {});
      return;
  }
}

#ifdef ANDROID

constexpr MapBuffer::Key PROPS_NATIVE_ID = 1;

void Props::propsDiffMapBuffer(
    const Props* oldPropsPtr,
    MapBufferBuilder& builder) const {
  // Call with default props if necessary
  if (oldPropsPtr == nullptr) {
    Props defaultProps{};
    propsDiffMapBuffer(&defaultProps, builder);
    return;
  }

  const Props& oldProps = *oldPropsPtr;
  const Props& newProps = *this;

  if (oldProps.nativeId != newProps.nativeId) {
    builder.putString(PROPS_NATIVE_ID, nativeId);
  }
}
#endif

} // namespace ABI50_0_0facebook::ABI50_0_0React
