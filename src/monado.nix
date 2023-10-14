{ lib
, stdenv
, fetchFromGitLab
, fetchFromGitHub
, writeText
, cmake
, doxygen
, glslang
, pkg-config
, python3
, SDL2
, bluez
, dbus
, eigen
, ffmpeg
, gst-plugins-base
, gstreamer
, hidapi
, libGL
, libXau
, libXdmcp
, libXrandr
, libbsd
, libffi
, libjpeg
# , librealsense
, libsurvive
, libusb1
, libuv
, libuvc
, libv4l
, libxcb
, onnxruntime
, opencv4
, openvr
, udev
, vulkan-headers
, vulkan-loader
, wayland
, wayland-protocols
, wayland-scanner
, libdrm
, zlib
# Set as 'false' to build monado without service support, i.e. allow VR
# applications linking against libopenxr_monado.so to use OpenXR standalone
# instead of via the monado-service program. For more information see:
# https://gitlab.freedesktop.org/monado/monado/-/blob/master/doc/targets.md#xrt_feature_service-disabled
, serviceSupport ? true
}:

#let
#  openhmdG2Branch = openhmd.overrideAttrs (old: {
#    version = "2023-10-13";
#    src = fetchFromGitHub {
#      owner = "thaytan";
#      repo = "OpenHMD";
#      rev = "dev-reverb-g2";
#      sha256 = "sha256-AVbU2dSaSSrW7n6WTSPQzNzAf0DZNnJljFNmlr7YMSE=";
#    };
#  });
#in
stdenv.mkDerivation rec {
  pname = "monado";
  version = "unstable-2023-10-14";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "monado";
    rev = "668a7a8bb9d912c6a459f5a31815a6ac38960da7";
    sha256 = "sha256-6aQJ6rI2uwmfdHUAB3uSRY2e5+nPodx8ExDAJV5eE24=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    glslang
    pkg-config
    python3
  ];

  cmakeFlags = [
    "-DXRT_FEATURE_SERVICE=${if serviceSupport then "ON" else "OFF"}"
    "-DXRT_OPENXR_INSTALL_ABSOLUTE_RUNTIME_PATH=ON"
  ];

  buildInputs = [
    SDL2
    bluez
    dbus
    eigen
    ffmpeg
    gst-plugins-base
    gstreamer
    hidapi
    libGL
    libXau
    libXdmcp
    libXrandr
    libbsd
    libjpeg
    libffi
    # librealsense.dev - see below
    libsurvive
    libusb1
    libuv
    libuvc
    libv4l
    libxcb
    onnxruntime
    opencv4
    #openhmdG2Branch
    openvr
    udev
    vulkan-headers
    vulkan-loader
    wayland
    wayland-scanner
    wayland-protocols
    libdrm
    zlib
  ];

  # known disabled drivers:
  #  - DRIVER_DEPTHAI - Needs depthai-core https://github.com/luxonis/depthai-core
  #  - DRIVER_ILLIXR - needs ILLIXR headers https://github.com/ILLIXR/ILLIXR
  #  - DRIVER_REALSENSE - see below
  #  - DRIVER_SIMULAVR - needs realsense
  #  - DRIVER_ULV2 - needs proprietary Leapmotion SDK https://api.leapmotion.com/documentation/v2/unity/devguide/Leap_SDK_Overview.html

  # realsense is disabled, the build ends with the following error:
  #
  # CMake Error in src/xrt/drivers/CMakeLists.txt:
  # Imported target "realsense2::realsense2" includes non-existent path
  # "/nix/store/2v95aps14hj3jy4ryp86vl7yymv10mh0-librealsense-2.41.0/include"
  # in its INTERFACE_INCLUDE_DIRECTORIES.
  #
  # for some reason cmake is trying to use ${librealsense}/include
  # instead of ${librealsense.dev}/include as an include directory

  # Help openxr-loader find this runtime
  setupHook = writeText "setup-hook" ''
    export XDG_CONFIG_DIRS=@out@/etc/xdg''${XDG_CONFIG_DIRS:+:''${XDG_CONFIG_DIRS}}
  '';

  patches = [
    # We don't have $HOME/.steam when building
    ./force-enable-steamvr_lh.patch

    # A recent (as of August 2023) SteamVR Beta has upgraded a driver interface which is incompatible with Monado
    #./steamvr_lh-use-old-interface.patch
  ];

  meta = with lib; {
    description = "Open source XR runtime";
    homepage = "https://monado.freedesktop.org/";
    license = licenses.boost;
    maintainers = with maintainers; [ expipiplus1 prusnak ];
    platforms = platforms.linux;
    mainProgram = "monado-cli";
  };
}
