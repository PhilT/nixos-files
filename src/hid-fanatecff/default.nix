{ lib
, stdenv
, fetchFromGitHub
, kernel
, kmod
, linuxConsoleTools
}:

let moduledir = "lib/modules/${kernel.version}/kernel/drivers/hid";
in
stdenv.mkDerivation rec {
  pname = "hid-fanatecff";
  version = "0.0.3";
  name = "hid-fanatecff-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "gotzl";
    repo = "hid-fanatecff";
    rev = "next";
    sha256 = "U5lWGQuTdsa/gshCApnA/JVj7kPXPtQYTy+kMdbqycw=";
  };

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  patchPhase = ''
    mkdir -p $out/lib/udev/rules.d
    mkdir -p $out/${moduledir}
    substituteInPlace Makefile --replace "/etc/udev/rules.d" "$out/lib/udev/rules.d"
    substituteInPlace fanatec.rules --replace "/usr/bin/evdev-joystick" "${linuxConsoleTools}/bin/evdev-joystick" --replace "/bin/sh" "${stdenv.shell}"
    sed -i '/depmod/d' Makefile
  '';

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "MODULEDIR=$(out)/${moduledir}"
  ];
}