// Copyright 2022-present 650 Industries. All rights reserved.

#pragma once

#ifdef __cplusplus

#include <folly/dynamic.h>
#include <react/renderer/components/view/ViewProps.h>
#include <react/renderer/core/PropsParserContext.h>

namespace ABI50_0_0expo {

class ExpoViewProps final : public ABI50_0_0facebook::ABI50_0_0React::ViewProps {
public:
  ExpoViewProps() = default;
  ExpoViewProps(const ABI50_0_0facebook::ABI50_0_0React::PropsParserContext &context,
                const ExpoViewProps &sourceProps,
                const ABI50_0_0facebook::ABI50_0_0React::RawProps &rawProps);

#pragma mark - Props

  /**
   A map with props stored as `folly::dynamic` objects.
   */
  std::unordered_map<std::string, folly::dynamic> propsMap;
};

} // namespace ABI50_0_0expo

#endif // __cplusplus
