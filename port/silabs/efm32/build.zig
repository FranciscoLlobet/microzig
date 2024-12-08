const std = @import("std");
const microzig = @import("microzig/build-internals");

const Self = @This();

const KiB: usize = 1024;
const RAM_SIZE: usize = 128 * KiB;
const FLASH_SIZE: usize = 1024 * KiB;

chips: struct {
    efm32gg390f1024: *const microzig.Target,
},

boards: struct {},

pub fn init(dep: *std.Build.Dependency) Self {
    const b = dep.builder;
    //const chips = Chips.init(dep);

    const chip_efm32gg390f1024: microzig.Target = .{
        .dep = dep,
        .preferred_binary_format = .elf,
        .chip = .{
            .name = "EFM32GG390F1024",
            .cpu = .{
                .cpu_arch = .thumb,
                .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m3 },
                .os_tag = .freestanding,
                .abi = .eabi,
            },
            .register_definition = .{ .svd = b.path("src/chips/EFM32GG390F1024.svd") },
            .memory_regions = &.{
                .{ .offset = 0x00000000, .length = FLASH_SIZE, .kind = .flash },
                .{ .offset = 0x20000000, .length = RAM_SIZE, .kind = .ram }, // RAM
            },
        },
    };

    return .{
        .chips = .{
            .efm32gg390f1024 = chip_efm32gg390f1024.derive(.{}),
        },
        .boards = .{},
    };
}

pub fn build(b: *std.Build) !void {
    //   const update = b.step("update", "Update chip definitions from embassy-rs/stm32-data-generated");

    //   const stm32_data_generated = b.lazyDependency("stm32-data-generated", .{}) orelse return;

    //   const regz_dep = b.dependency("microzig/tools/regz", .{});
    //  const regz = regz_dep.module("regz");

    //   const generate = b.addExecutable(.{
    //        .name = "generate",
    //        .root_source_file = b.path("src/generate.zig"),
    //        .target = b.host,
    //        .optimize = .Debug,
    //    });
    //    generate.root_module.addImport("regz", regz);
    //
    //    const generate_run = b.addRunArtifact(generate);
    //    generate_run.max_stdio_size = std.math.maxInt(usize);
    //    generate_run.addFileArg(stm32_data_generated.path("."));
    //    update.dependOn(&generate_run.step);

    _ = b.step("test", "Run platform agnostic unit tests");
}
