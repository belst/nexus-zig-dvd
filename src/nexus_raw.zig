const windows = @import("std").os.windows;

pub const ERenderType_PreRender: c_int = 0;
pub const ERenderType_Render: c_int = 1;
pub const ERenderType_PostRender: c_int = 2;
pub const ERenderType_OptionsRender: c_int = 3;
pub const enum_ERenderType = c_uint;
pub const ERenderType = enum_ERenderType;
pub const GUI_RENDER = *const fn () callconv(.C) void;
pub const GUI_ADDRENDER = *const fn (ERenderType, GUI_RENDER) callconv(.C) void;
pub const GUI_REMRENDER = *const fn (GUI_RENDER) callconv(.C) void;
pub const PATHS_GETGAMEDIR = *const fn () callconv(.C) [*:0]const u8;
pub const PATHS_GETADDONDIR = *const fn ([*:0]const u8) callconv(.C) [*:0]const u8;
pub const PATHS_GETCOMMONDIR = *const fn () callconv(.C) [*:0]const u8;
pub const MH_UNKNOWN: c_int = -1;
pub const MH_OK: c_int = 0;
pub const MH_ERROR_ALREADY_INITIALIZED: c_int = 1;
pub const MH_ERROR_NOT_INITIALIZED: c_int = 2;
pub const MH_ERROR_ALREADY_CREATED: c_int = 3;
pub const MH_ERROR_NOT_CREATED: c_int = 4;
pub const MH_ERROR_ENABLED: c_int = 5;
pub const MH_ERROR_DISABLED: c_int = 6;
pub const MH_ERROR_NOT_EXECUTABLE: c_int = 7;
pub const MH_ERROR_UNSUPPORTED_FUNCTION: c_int = 8;
pub const MH_ERROR_MEMORY_ALLOC: c_int = 9;
pub const MH_ERROR_MEMORY_PROTECT: c_int = 10;
pub const MH_ERROR_MODULE_NOT_FOUND: c_int = 11;
pub const MH_ERROR_FUNCTION_NOT_FOUND: c_int = 12;
pub const enum_EMHStatus = c_int;
pub const EMHStatus = enum_EMHStatus;
pub const MINHOOK_CREATE = *const fn (windows.LPVOID, windows.LPVOID, *windows.LPVOID) callconv(.C) EMHStatus;
pub const MINHOOK_REMOVE = *const fn (windows.LPVOID) callconv(.C) EMHStatus;
pub const MINHOOK_ENABLE = *const fn (windows.LPVOID) callconv(.C) EMHStatus;
pub const MINHOOK_DISABLE = *const fn (windows.LPVOID) callconv(.C) EMHStatus;
pub const ELogLevel_OFF: c_int = 0;
pub const ELogLevel_CRITICAL: c_int = 1;
pub const ELogLevel_WARNING: c_int = 2;
pub const ELogLevel_INFO: c_int = 3;
pub const ELogLevel_DEBUG: c_int = 4;
pub const ELogLevel_TRACE: c_int = 5;
pub const ELogLevel_ALL: c_int = 6;
pub const enum_ELogLevel = c_uint;
pub const ELogLevel = enum_ELogLevel;
pub const LOGGER_LOG2 = *const fn (ELogLevel, [*:0]const u8, [*:0]const u8) callconv(.C) void;
pub const EVENT_CONSUME = *const fn (*anyopaque) callconv(.C) void;
pub const EVENTS_RAISE = *const fn ([*:0]const u8, *anyopaque) callconv(.C) void;
pub const EVENTS_RAISENOTIFICATION = *const fn ([*:0]const u8) callconv(.C) void;
pub const EVENTS_SUBSCRIBE = *const fn ([*:0]const u8, EVENT_CONSUME) callconv(.C) void;
pub const WNDPROC_CALLBACK = *const fn (windows.HWND, windows.UINT, windows.WPARAM, windows.LPARAM) callconv(.C) windows.UINT;
pub const WNDPROC_ADDREM = *const fn (WNDPROC_CALLBACK) callconv(.C) void;
pub const WNDPROC_SENDTOGAME = *const fn (windows.HWND, windows.UINT, windows.WPARAM, windows.LPARAM) callconv(.C) windows.LRESULT;
pub const struct_Keybind = extern struct {
    Key: c_ushort,
    Alt: bool,
    Ctrl: bool,
    Shift: bool,
};
pub const Keybind = struct_Keybind;
pub const KEYBINDS_PROCESS = *const fn ([*:0]const u8) callconv(.C) void;
pub const KEYBINDS_REGISTERWITHSTRING = *const fn ([*:0]const u8, KEYBINDS_PROCESS, [*:0]const u8) callconv(.C) void;
pub const KEYBINDS_REGISTERWITHSTRUCT = *const fn ([*:0]const u8, KEYBINDS_PROCESS, Keybind) callconv(.C) void;
pub const KEYBINDS_DEREGISTER = *const fn ([*:0]const u8) callconv(.C) void;
pub const DATALINK_GETRESOURCE = *const fn ([*:0]const u8) callconv(.C) ?*anyopaque;
pub const DATALINK_SHARERESOURCE = *const fn ([*:0]const u8, usize) callconv(.C) *anyopaque;
pub const struct_Texture = extern struct {
    Width: c_uint,
    Height: c_uint,
    Resource: *anyopaque,
};
pub const Texture = struct_Texture;
pub const TEXTURES_RECEIVECALLBACK = *const fn ([*:0]const u8, *Texture) callconv(.C) void;
pub const TEXTURES_GET = *const fn ([*:0]const u8) callconv(.C) ?*Texture;
pub const TEXTURES_GETORCREATEFROMFILE = *const fn ([*:0]const u8, [*:0]const u8) callconv(.C) *Texture;
pub const TEXTURES_GETORCREATEFROMRESOURCE = *const fn ([*:0]const u8, c_uint, windows.HMODULE) callconv(.C) *Texture;
pub const TEXTURES_GETORCREATEFROMURL = *const fn ([*:0]const u8, [*:0]const u8, [*:0]const u8) callconv(.C) *Texture;
pub const TEXTURES_GETORCREATEFROMMEMORY = *const fn ([*:0]const u8, ?*anyopaque, usize) callconv(.C) *Texture;
pub const TEXTURES_LOADFROMFILE = *const fn ([*:0]const u8, [*:0]const u8, TEXTURES_RECEIVECALLBACK) callconv(.C) void;
pub const TEXTURES_LOADFROMRESOURCE = *const fn ([*:0]const u8, c_uint, windows.HMODULE, TEXTURES_RECEIVECALLBACK) callconv(.C) void;
pub const TEXTURES_LOADFROMURL = *const fn ([*:0]const u8, [*:0]const u8, [*:0]const u8, TEXTURES_RECEIVECALLBACK) callconv(.C) void;
pub const TEXTURES_LOADFROMMEMORY = *const fn ([*:0]const u8, ?*anyopaque, usize, TEXTURES_RECEIVECALLBACK) callconv(.C) void;
pub const QUICKACCESS_ADDSHORTCUT = *const fn ([*:0]const u8, [*:0]const u8, [*:0]const u8, [*:0]const u8, [*:0]const u8) callconv(.C) void;
pub const QUICKACCESS_ADDSIMPLE = *const fn ([*:0]const u8, GUI_RENDER) callconv(.C) void;
pub const QUICKACCESS_GENERIC = *const fn ([*:0]const u8) callconv(.C) void;
pub const LOCALIZATION_TRANSLATE = *const fn ([*:0]const u8) callconv(.C) [*:0]const u8;
pub const LOCALIZATION_TRANSLATETO = *const fn ([*:0]const u8, [*:0]const u8) callconv(.C) [*:0]const u8;
pub const struct_NexusLinkData = extern struct {
    Width: c_uint,
    Height: c_uint,
    Scaling: f32,
    IsMoving: bool,
    IsCameraMoving: bool,
    IsGameplay: bool,
    Font: ?*anyopaque,
    FontBig: ?*anyopaque,
    FontUI: ?*anyopaque,
};
pub const NexusLinkData = struct_NexusLinkData;
pub const struct_AddonAPI = extern struct {
    SwapChain: *anyopaque,
    ImguiContext: *anyopaque,
    ImguiMalloc: *anyopaque,
    ImguiFree: *anyopaque,
    RegisterRender: GUI_ADDRENDER,
    DeregisterRender: GUI_REMRENDER,
    GetGameDirectory: PATHS_GETGAMEDIR,
    GetAddonDirectory: PATHS_GETADDONDIR,
    GetCommonDirectory: PATHS_GETCOMMONDIR,
    CreateHook: MINHOOK_CREATE,
    RemoveHook: MINHOOK_REMOVE,
    EnableHook: MINHOOK_ENABLE,
    DisableHook: MINHOOK_DISABLE,
    Log: LOGGER_LOG2,
    RaiseEvent: EVENTS_RAISE,
    RaiseEventNotification: EVENTS_RAISENOTIFICATION,
    SubscribeEvent: EVENTS_SUBSCRIBE,
    UnsubscribeEvent: EVENTS_SUBSCRIBE,
    RegisterWndProc: WNDPROC_ADDREM,
    DeregisterWndProc: WNDPROC_ADDREM,
    SendWndProcToGameOnly: WNDPROC_SENDTOGAME,
    RegisterKeybindWithString: KEYBINDS_REGISTERWITHSTRING,
    RegisterKeybindWithStruct: KEYBINDS_REGISTERWITHSTRUCT,
    DeregisterKeybind: KEYBINDS_DEREGISTER,
    GetResource: DATALINK_GETRESOURCE,
    ShareResource: DATALINK_SHARERESOURCE,
    GetTexture: TEXTURES_GET,
    GetTextureOrCreateFromFile: TEXTURES_GETORCREATEFROMFILE,
    GetTextureOrCreateFromResource: TEXTURES_GETORCREATEFROMRESOURCE,
    GetTextureOrCreateFromURL: TEXTURES_GETORCREATEFROMURL,
    GetTextureOrCreateFromMemory: TEXTURES_GETORCREATEFROMMEMORY,
    LoadTextureFromFile: TEXTURES_LOADFROMFILE,
    LoadTextureFromResource: TEXTURES_LOADFROMRESOURCE,
    LoadTextureFromURL: TEXTURES_LOADFROMURL,
    LoadTextureFromMemory: TEXTURES_LOADFROMMEMORY,
    AddShortcut: QUICKACCESS_ADDSHORTCUT,
    RemoveShortcut: QUICKACCESS_GENERIC,
    NotifyShortcut: QUICKACCESS_GENERIC,
    AddSimpleShortcut: QUICKACCESS_ADDSIMPLE,
    RemoveSimpleShortcut: QUICKACCESS_GENERIC,
    Translate: LOCALIZATION_TRANSLATE,
    TranslateTo: LOCALIZATION_TRANSLATETO,
};
pub const AddonAPI = struct_AddonAPI;
pub const ADDON_LOAD = *const fn (*const AddonAPI) callconv(.C) void;
pub const ADDON_UNLOAD = *const fn () callconv(.C) void;
pub const struct_AddonVersion = extern struct {
    Major: c_short,
    Minor: c_short,
    Build: c_short,
    Revision: c_short,
};
pub const AddonVersion = struct_AddonVersion;
pub const EAddonFlags_None: c_int = 0;
pub const EAddonFlags_IsVolatile: c_int = 1;
pub const EAddonFlags_DisableHotloading: c_int = 2;
pub const enum_EAddonFlags = c_uint;
pub const EAddonFlags = enum_EAddonFlags;
pub const EUpdateProvider_None: c_int = 0;
pub const EUpdateProvider_Raidcore: c_int = 1;
pub const EUpdateProvider_GitHub: c_int = 2;
pub const EUpdateProvider_Direct: c_int = 3;
pub const enum_EUpdateProvider = c_uint;
pub const EUpdateProvider = enum_EUpdateProvider;
pub const struct_AddonDefinition = extern struct {
    Signature: c_int,
    APIVersion: c_int,
    Name: [*:0]const u8,
    Version: AddonVersion,
    Author: [*:0]const u8,
    Description: [*:0]const u8,
    Load: ADDON_LOAD,
    Unload: ADDON_UNLOAD,
    Flags: EAddonFlags,
    Provider: EUpdateProvider,
    UpdateLink: ?[*:0]const u8,
};
pub const AddonDefinition = struct_AddonDefinition;
