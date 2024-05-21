const common = @import("nexus.zig");
const nexus = common.nexus;
const imgui = @import("imgui");
const logm = @import("log.zig");
const dvd = @import("dvd.zig");
const std = @import("std");
const settings = @import("settings.zig");

pub const std_options = struct {
    pub const log_level = .debug;
    pub const logFn = logm.logfn;
};

export fn render() callconv(.C) void {
    dvd.renderLogo();
}

fn registerRender() void {
    common.API.RegisterRender(nexus.ERenderType_Render, render);
}
fn unregisterRender() void {
    common.API.DeregisterRender(render);
}

fn setupImgui() void {
    const api = common.API;
    imgui.SetCurrentContext(@ptrCast(api.ImguiContext));
    imgui.SetAllocatorFunctions(@ptrCast(api.ImguiMalloc), @ptrCast(api.ImguiFree));
}

export fn load(api: *const nexus.AddonAPI) callconv(.C) void {
    common.API = api;
    setupImgui();
    settings.init();
    registerRender();
    dvd.init();
    std.log.info("Loaded", .{});
}
export fn unload() callconv(.C) void {
    unregisterRender();
    settings.deinit();
    std.log.info("Unloaded", .{});
}

export fn GetAddonDef() callconv(.C) *const nexus.AddonDefinition {
    // zig fmt: off
    const AD = .{
        .Signature = -0xBABE,
        .APIVersion = 2,
        .Name = "zig-dvd",
        .Version = .{
            .Major = 0,
            .Minor = 1,
            .Build = 0,
            .Revision = 1,
        },
        .Author = "belst",
        .Description = "Zig version of dvd.dll",
        .Load = load,
        .Unload = unload,
        .Flags = nexus.EAddonFlags_None,
        .Provider = nexus.EUpdateProvider_None,
        .UpdateLink = null
    };

    return &AD;
}
