const common = @import("nexus.zig");
const nexus = common.nexus;
const std = @import("std");
const fmt = std.fmt;
const imgui = @import("imgui");
const settings = @import("settings.zig");

fn concat(prefix: [*:0]const u8, msg: [*:0]const u8) ![:0]const u8 {
    return std.fmt.allocPrintZ(common.alloc, "{s}{s}", .{ prefix, msg });
}

var dvd: ?nexus.Texture = undefined;

export fn receiveTexture(_: [*:0]const u8, texture: *nexus.Texture) callconv(.C) void {
    dvd = texture.*;
    if (dvd) |d| {
        dvdstate.* = DvdState.new(d);
    }
}

fn getLogoPath() ![:0]const u8 {
    const path = common.API.GetAddonDirectory("zig-dvd");
    return concat(path, "\\zig-mark.png");
}

export fn loadLogo() callconv(.C) void {
    const path = getLogoPath() catch return;
    defer common.alloc.free(path);
    common.API.LoadTextureFromResource("ZIG_LOGO", 101, common.MODULE, @ptrCast(&receiveTexture));
    // common.API.LoadTextureFromFile("ZIG_LOGO", path, @ptrCast(&receiveTexture));
}

pub fn init() void {
    common.init_nexus_data();
    loadLogo();
}

fn getrandomcolor() imgui.Color {
    var rnd = std.rand.DefaultPrng.init(@bitCast(std.time.milliTimestamp()));
    return imgui.Color.initRGB(
        rnd.random().float(f32),
        rnd.random().float(f32),
        rnd.random().float(f32),
    );
}

fn genrandpos() imgui.Vec2 {
    var rnd = std.rand.DefaultPrng.init(@bitCast(std.time.milliTimestamp()));
    if (common.NEXUS_DATA) |nd| {
        const rnd_x = rnd.random().float(f32);
        const rnd_y = rnd.random().float(f32);

        // hardcoded 200 instead of actual width/height of the texture
        // because lazy
        return .{ .x = rnd_x * @as(f32, @floatFromInt(nd.Width - 200)), .y = rnd_y * @as(f32, @floatFromInt(nd.Height - 200)) };
    } else {
        return .{ .x = 0.0, .y = 0.0 };
    }
}

fn genrandomdirection() imgui.Vec2 {
    var rnd = std.rand.DefaultPrng.init(@bitCast(std.time.milliTimestamp()));
    var options = [_]imgui.Vec2{
        .{ .x = -1, .y = -1 },
        .{ .x = -1, .y = 1 },
        .{ .x = 1, .y = -1 },
        .{ .x = 1, .y = 1 },
    };
    rnd.random().shuffle(imgui.Vec2, &options);
    return options[0];
}

const DvdState = struct {
    direction: imgui.Vec2 = .{},
    position: imgui.Vec2 = .{},
    color: imgui.Color = .{ .Value = .{} },
    size: imgui.Vec2 = .{},

    pub fn empty() DvdState {
        return .{};
    }

    pub fn step(self: *DvdState, speed: f32) void {
        self.position.x += speed * self.direction.x;
        self.position.y += speed * self.direction.y;
    }

    pub fn collide(self: *DvdState, bounds: imgui.Vec2) bool {
        var collided = false;
        if (self.position.x < 0) {
            self.direction.x = 1;
            collided = true;
        }
        if (self.position.x + self.size.x > bounds.x) {
            self.direction.x = -1;
            collided = true;
        }
        if (self.position.y < 0) {
            self.direction.y = 1;
            collided = true;
        }
        if (self.position.y + self.size.y > bounds.y) {
            self.direction.y = -1;
            collided = true;
        }
        return collided;
    }

    pub fn new(tex: nexus.Texture) DvdState {
        return .{
            .direction = genrandomdirection(),
            .position = genrandpos(),
            .size = .{ .x = @floatFromInt(tex.Width), .y = @floatFromInt(tex.Height) },
            .color = getrandomcolor(),
        };
    }
    pub fn simulate(self: *DvdState, bounds: imgui.Vec2) void {
        const S = struct {
            var timer: ?std.time.Timer = undefined;
        };
        if (S.timer) |_| {} else {
            S.timer = std.time.Timer.start() catch {
                return;
            };
        }
        const SPEED = settings.SETTINGS.speed;
        defer S.timer.?.reset();
        const elapsed = S.timer.?.read() / 1000000;
        const max_iterations = elapsed / 16;
        var iterations = max_iterations + 1;
        var collission = false;
        while (0 < iterations) {
            const delta = if (iterations == 1) elapsed - 16 * max_iterations else 16;
            iterations -= 1;
            collission = collission or self.collide(bounds);
            self.step(SPEED * @as(f32, @floatFromInt(delta)) / 16);
        }
        if (collission) {
            self.color = getrandomcolor();
        }
    }
    pub fn render(self: *DvdState) void {
        imgui.SetNextWindowPosExt(self.position, .{ .Always = true }, .{ .x = 0, .y = 0 });
        if (imgui.BeginExt("Dvd-Logo", null, .{
            .NoTitleBar = true,
            .NoResize = true,
            .NoMove = true,
            .NoScrollbar = true,
            .NoScrollWithMouse = true,
            .AlwaysAutoResize = true,
            .NoBackground = true,
            .NoMouseInputs = true,
            .NoFocusOnAppearing = true,
        })) {
            defer imgui.End();
            if (dvd) |d| {
                imgui.ImageExt(d.Resource, .{ .x = @floatFromInt(d.Width), .y = @floatFromInt(d.Height) }, .{ .x = 0, .y = 0 }, .{ .x = 1, .y = 1 }, self.color.Value, .{ .x = 0, .y = 0, .z = 0, .w = 0 });
            }
        }
    }
};

var dvdstate: *DvdState = @constCast(&DvdState.empty());

pub fn renderLogo() void {
    if (common.NEXUS_DATA) |nd| {
        if (nd.IsGameplay) {
            return;
        }
        dvdstate.simulate(.{ .x = @floatFromInt(nd.Width), .y = @floatFromInt(nd.Height) });
        dvdstate.render();
    } else {
        return;
    }
}
