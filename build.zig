const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{ .default_target = .{ .cpu_arch = .x86_64, .os_tag = .windows } });

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    // const zigstr = b.dependency("zigstr", .{
    //     .target = target,
    //     .optimize = optimize,
    // });

    const lib = b.addSharedLibrary(.{ .name = "zig-dvd", .root_source_file = .{ .path = "src/lib.zig" }, .target = target, .optimize = optimize });
    lib.linkLibC();

    // lib.addModule("zigstr", zigstr.module("zigstr"));

    lib.addObjectFile(.{
        .path = "./resource.res",
    });
    // lib.addWin32ResourceFile(.{ .file = .{ .path = "./resource.rc" } });

    const imgui_build = @import("zig-imgui/imgui_build.zig");
    imgui_build.prepareAndLink(b, lib);

    b.installArtifact(lib);
}
