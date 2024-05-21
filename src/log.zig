const common = @import("nexus.zig");
const nexus = common.nexus;
const std = @import("std");
const fmt = std.fmt;

pub fn logfn(comptime level: std.log.Level, comptime scope: @TypeOf(.EnumLiteral), comptime format: []const u8, args: anytype) void {
    const scope_prefix = if (scope == std.log.default_log_scope)
        ""
    else
        "[" ++ @tagName(scope) ++ "] ";

    const s = std.fmt.allocPrintZ(common.alloc, scope_prefix ++ format, args) catch return;
    defer common.alloc.free(s);
    switch (level) {
        .err => critical(s),
        .warn => warn(s),
        .info => info(s),
        .debug => debug(s),
    }
}

fn info(msg: [*:0]const u8) void {
    common.API.Log(nexus.ELogLevel_INFO, "zig-dvd", msg);
}
fn critical(msg: [*:0]const u8) void {
    common.API.Log(nexus.ELogLevel_CRITICAL, "zig-dvd", msg);
}
fn warn(msg: [*:0]const u8) void {
    common.API.Log(nexus.ELogLevel_WARNING, "zig-dvd", msg);
}
fn debug(msg: [*:0]const u8) void {
    common.API.Log(nexus.ELogLevel_DEBUG, "zig-dvd", msg);
}
