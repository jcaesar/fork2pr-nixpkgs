{ lib, stdenv, fetchFromGitHub, zlib, zstd, openssl, curl, cmake, ninja }:

stdenv.mkDerivation (finalAttrs: {
  pname = "rdkafka";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "confluentinc";
    repo = "librdkafka";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-2AURPvhpgdIm034KEMm7Tmf8Zx/XER76aT6SiINs6wg=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = [ zlib zstd openssl curl ];

  # some tests don't build on darwin
  cmakeFlags = [
    (lib.cmakeBool "RDKAFKA_BUILD_TESTS" (!stdenv.hostPlatform.isDarwin))
    (lib.cmakeBool "RDKAFKA_BUILD_EXAMPLES" (!stdenv.hostPlatform.isDarwin))
    (lib.cmakeFeature "CMAKE_C_FLAGS" "-Wno-error=strict-overflow")
  ];

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "librdkafka - Apache Kafka C/C++ client library";
    homepage = "https://github.com/confluentinc/librdkafka";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ commandodev ];
  };
})
