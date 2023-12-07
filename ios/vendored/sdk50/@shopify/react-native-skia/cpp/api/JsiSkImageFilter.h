#pragma once

#include <memory>
#include <utility>

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include "JsiSkHostObjects.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

#include "SkImageFilters.h"

#pragma clang diagnostic pop

namespace ABI50_0_0RNSkia {

namespace jsi = ABI50_0_0facebook::jsi;

class JsiSkImageFilter : public JsiSkWrappingSkPtrHostObject<SkImageFilter> {
public:
  JsiSkImageFilter(std::shared_ptr<ABI50_0_0RNSkPlatformContext> context,
                   sk_sp<SkImageFilter> imageFilter)
      : JsiSkWrappingSkPtrHostObject<SkImageFilter>(std::move(context),
                                                    std::move(imageFilter)) {}

  EXPORT_JSI_API_TYPENAME(JsiSkImageFilter, ImageFilter)
};

} // namespace ABI50_0_0RNSkia
