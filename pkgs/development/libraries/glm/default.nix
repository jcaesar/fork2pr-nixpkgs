{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  version = "1.0.1";
  pname = "glm";

  src = fetchFromGitHub {
    owner = "g-truc";
    repo = pname;
    rev = version;
    sha256 = "sha256-GnGyzNRpzuguc3yYbEFtYLvG+KiCtRAktiN+NvbOICE=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ cmake ];

  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102823
  env.NIX_CFLAGS_COMPILE = lib.optionalString (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11") "-fno-ipa-modref";

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
    (lib.cmakeBool "BUILD_STATIC_LIBS" false)
    (lib.cmakeBool "GLM_TEST_ENABLE" doCheck)
    # Avoid failure on mac
    # /tmp/nix-build-glm-1.0.1.drv-0/source/glm/detail/func_packing.inl:165:3: error: unsafe buffer access [-Werror,-Wunsafe-buffer-usage]
    #             u.in[1] = detail::toFloat16(v.y);
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-error")
  ];

  doCheck = true;

  postInstall = ''
    # Install pkg-config file
    mkdir -p $out/lib/pkgconfig
    substituteAll ${./glm.pc.in} $out/lib/pkgconfig/glm.pc

    # Install docs
    mkdir -p $doc/share/doc/glm
    cp -rv ../doc/api $doc/share/doc/glm/html
    cp -v ../doc/manual.pdf $doc/share/doc/glm
  '';

  meta = with lib; {
    description = "OpenGL Mathematics library for C++";
    longDescription = ''
      OpenGL Mathematics (GLM) is a header only C++ mathematics library for
      graphics software based on the OpenGL Shading Language (GLSL)
      specification and released under the MIT license.
    '';
    homepage = "https://github.com/g-truc/glm";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ smancill ];
  };
}

