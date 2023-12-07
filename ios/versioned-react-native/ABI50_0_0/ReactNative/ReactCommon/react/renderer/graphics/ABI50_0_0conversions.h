/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/core/ABI50_0_0graphicsConversions.h>

// This file belongs to the ABI50_0_0React-graphics module.
// This file also used to have a reference to two files that are located in the
// ABI50_0_0React/renderer/core folder. That folder belongs to a module that is called
// ABI50_0_0React-Fabric.
// The ABI50_0_0React-Fabric module declares an explicit dependency on
// ABI50_0_0React-graphics. Including those files in a ABI50_0_0React-graphics' file created a
// circular dependency because ABI50_0_0React-Fabric was explicitly depending on
// ABI50_0_0React-graphics, which was implicitly depending on ABI50_0_0React-Fabric. We break that
// dependency by moving the old `graphics/conversions.h` file to the
// ABI50_0_0React-Fabric module and renaming it `core/graphicsConversions.h`.

#warning \
    "[DEPRECATION] `graphics/conversions.h` is deprecated and will be removed in the future. \
    If this warning appears due to a library, please open an issue in that library, and ask for an update. \
    Please, replace the `#include <ABI50_0_0React/ABI50_0_0renderer/graphics/conversions.h>` statements \
    with `#include <ABI50_0_0React/ABI50_0_0renderer/core/graphicsConversions.h>`."
