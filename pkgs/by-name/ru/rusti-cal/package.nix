{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
, pkgsBuildBuild
}:

rustPlatform.buildRustPackage rec {
  pname = "rusti-cal";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "arthurhenrique";
    repo = "rusti-cal";
    rev = "v${version}";
    hash = "sha256-pdsP2nuJh30BzqIyxSQXak/rceA4hI9jBYy1dDVEIvI=";
  };

  cargoHash = "sha256-5eS+OMaNAVNyDMKFNfb0J0rLsikw2LCXhWk7MS9UV2k=";

  # preBuild = "${pkgsBuildBuild.strace}/bin/strace -ff -e openat,fstat,stat cargo build --target wasm32-wasip1";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
  ];

  # env.NIX_DEBUG = "1";
  # env.RUSTC_LOG = "rustc_codegen_ssa::back::link=info";

  meta = with lib; {
    description = "Minimal command line calendar, similar to cal";
    mainProgram = "rusti-cal";
    homepage = "https://github.com/arthurhenrique/rusti-cal";
    license = [ licenses.mit ];
    maintainers = [ maintainers.detegr ];
  };
}
