{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # buildInputs
  libiconv,

  # nativeBuildInputs
  rustPlatform,

  # tests
  anyio,
  objsize,
  pydantic,
  pytestCheckHook,
  trio,
  y-py,

  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pycrdt";
  version = "0.10.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-server";
    repo = "pycrdt";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z7u0ix9IjXaq0OKgH3Yvt5cAmAYSCyHT/ZcPLANuVzU=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  dependencies = [ anyio ];

  pythonImportsCheck = [ "pycrdt" ];

  nativeCheckInputs = [
    anyio
    objsize
    pydantic
    pytestCheckHook
    trio
    y-py
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "CRDTs based on Yrs";
    homepage = "https://github.com/jupyter-server/pycrdt";
    changelog = "https://github.com/jupyter-server/pycrdt/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = lib.licenses.mit;
    maintainers = lib.teams.jupyter.members;
  };
}
