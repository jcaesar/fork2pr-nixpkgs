# When used from pkgsStatic, this provides qemu-user-static
{
  lib,
  qemu,
}:

let

  qemuUserPlatforms = [
    "aarch64-linux"
    "armv7l-linux"
    "i386-linux"
    "powerpc-linux"
    "powerpc64-linux"
    "powerpc64le-linux"
    "riscv32-linux"
    "riscv64-linux"
    "x86_64-linux"
  ];

  qemuTargets = map (system: (lib.systems.elaborate { inherit system; }).qemuArch + "-linux-user") qemuUserPlatforms;

  qemuUser = (qemu.override {
    guestAgentSupport = false;
    numaSupport = false;
    seccompSupport = false;
    alsaSupport = false;
    pulseSupport = false;
    sdlSupport = false;
    jackSupport = false;
    pipewireSupport = false;
    gtkSupport = false;
    vncSupport = false;
    smartcardSupport = false;
    spiceSupport = false;
    ncursesSupport = false;
    libiscsiSupport = false;
    smbdSupport = false;
    tpmSupport = false;
    uringSupport = false;
    capstoneSupport = false;
    enableDocs = false;
    enableTools = false;
    enableBlobs = false;
    hostCpuTargets = qemuTargets;
  }).overrideAttrs (old: {
    # HACK: Otherwise the result will have the entire buildinput closure
    # injected by the pkgsStatic stdenv
    # <https://github.com/NixOS/nixpkgs/issues/83667>
    postFixup = (old.postFixup or "") + ''
      rm -f $out/nix-support/propagated-build-inputs
    '';

    meta = old.meta // {
      platforms = lib.platforms.linux;
      description = "QEMU User space emulator - launch executables compiled for one CPU on another CPU";
    };
  });
in qemuUser // {
  passthru = (qemuUser.passthru or {}) // {
    inherit qemuUserPlatforms;
  };
}
