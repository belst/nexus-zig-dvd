const std = @import("std");
const common = @import("nexus.zig");

const Settings = struct {
    show_during_gameplay: bool = false,
    speed: f32 = 2,
    dvd_count: u32 = 1,
    use_file: bool = false,

    pub fn store(self: *@This(), path: [*:0]const u8, filename: [*:0]const u8) !void {
        std.log.debug("Storing to {s}\\{s}", .{ path, filename });
        try std.fs.makeDirAbsoluteZ(path);
        var dir = try std.fs.openDirAbsoluteZ(path, .{});
        defer dir.close();
        const file = try dir.createFileZ(filename, .{ .truncate = true, .read = false });
        defer file.close();
        try std.json.stringify(self, .{
            .whitespace = .indent_2,
        }, file.writer());
    }

    pub fn load(path: [*:0]const u8, filename: [*:0]const u8) !@This() {
        std.log.debug("Loading from {s}\\{s}", .{ path, filename });
        var dir = try std.fs.openDirAbsoluteZ(path, .{});
        defer dir.close();
        const file = try dir.openFileZ(filename, .{});
        defer file.close();
        const filereader = file.reader();
        var reader = std.json.reader(common.alloc, filereader);
        defer reader.deinit();
        const v = try std.json.parseFromTokenSource(@This(), common.alloc, &reader, .{});
        defer v.deinit();
        return v.value;
    }
};

pub var SETTINGS: Settings = .{};

pub fn init() void {
    const path = common.API.GetAddonDirectory("zig-dvd");
    std.log.debug("Addon Path: {s}", .{path});
    // SETTINGS = Settings.load(path, "config.json") catch return;
}

pub fn deinit() void {
    // SETTINGS.store(common.API.GetAddonDirectory("zig-dvd"), "config.json") catch return;
}

test "loading settings" {
    const settings = try Settings.load("D:\\Guild Wars 2\\addons\\zig-dvd", "config.json");
    std.debug.print("{}", .{settings.speed});
}
