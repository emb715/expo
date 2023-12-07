# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

package = JSON.parse(File.read(File.join(__dir__, "..", "..", "..", "package.json")))
version = package['version']



Pod::Spec.new do |s|
  s.name                   = "ABI50_0_0React-debug"
  s.version                = version
  s.summary                = "-"  # TODO
  s.homepage               = "https://reactnative.dev/"
  s.license                = package["license"]
  s.author                 = "Meta Platforms, Inc. and its affiliates"
  s.platforms              = min_supported_versions
  s.source                 = { :path => "." }
  s.source_files           = "**/*.{cpp,h}"
  s.header_dir             = "ABI50_0_0react/debug"
  s.pod_target_xcconfig    = { "CLANG_CXX_LANGUAGE_STANDARD" => "c++20",
                               "DEFINES_MODULE" => "YES" }

  if ENV['USE_FRAMEWORKS']
    s.module_name            = "ABI50_0_0React_debug"
    s.header_mappings_dir  = "../.."
  end
end
