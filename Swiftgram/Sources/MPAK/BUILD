# Swiftgram/Sources/MPAK/BUILD
# Add this file to include MPAK module in Swiftgram build

load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "MPAK",
    srcs = glob(["*.swift"]),
    module_name = "MPAK",
    visibility = ["//visibility:public"],
    deps = [
        "//submodules/Postbox:Postbox",
        "//submodules/TelegramCore:TelegramCore",
    ],
)
