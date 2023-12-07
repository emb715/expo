/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0ValueFactoryEventPayload.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

ValueFactoryEventPayload::ValueFactoryEventPayload(ValueFactory factory)
    : valueFactory_(std::move(factory)) {}

jsi::Value ValueFactoryEventPayload::asJSIValue(jsi::Runtime& runtime) const {
  return valueFactory_(runtime);
}

EventPayloadType ValueFactoryEventPayload::getType() const {
  return EventPayloadType::ValueFactory;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
