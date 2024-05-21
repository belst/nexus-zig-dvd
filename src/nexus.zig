pub const nexus = @import("nexus_raw.zig");
const std = @import("std");
const windows = @import("std").os.windows;

pub var API: *const nexus.AddonAPI = undefined;
pub var NEXUS_DATA: ?*nexus.NexusLinkData = undefined;

pub var MODULE: windows.HMODULE = undefined;

pub fn init_nexus_data() void {
    NEXUS_DATA = @ptrCast(@alignCast(API.GetResource("DL_NEXUS_LINK")));
}

pub const alloc = std.heap.c_allocator;

export fn DllMain(
    hinstDLL: windows.HINSTANCE, // handle to DLL module
    fdwReason: windows.DWORD, // reason for calling function
    _: windows.LPVOID,
) callconv(.C) windows.BOOL {
    switch (fdwReason) {
        1 => {
            MODULE = @ptrCast(hinstDLL);
        },
        else => {},
    }
    return 1;
}
