{
  lib,
  antlr4-python3-runtime,
  asciimatics,
  buildPythonPackage,
  click,
  dacite,
  decorator,
  fetchFromGitHub,
  future,
  first,
  jsonpath-ng,
  loguru,
  overrides,
  pillow,
  ply,
  pyfiglet,
  pyperclip,
  pytestCheckHook,
  pythonOlder,
  antlr4_8,
  pyyaml,
  setuptools,
  six,
  urwid,
  parameterized,
  wcwidth,
  yamale,
}: let

  antlr4-python3-runtime' = antlr4-python3-runtime.override { antlr4 = antlr4_8; };
  antlr4-python3-runtime'' = antlr4-python3-runtime'.overrideAttrs {
    postPatch = "";
    prePatch = "mkdir tests; touch tests/run.py;";
  };
  urwid'' = urwid.overridePythonAttrs {
    version = "2.1.1";
    src = urwid.src.override {
      rev = "refs/tags/release-2.1.1";
      hash = "sha256-up3pXS/O2ztBf5BGZ1B+U+ROotWQPH4R3TWpSoqu0dU=";
    };
    postPatch = "";
    pytestCheckPhase = "rm -rf uwid/tests/";
  };

in buildPythonPackage rec {
  pname = "python-fx";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cielong";
    repo = "pyfx";
    rev = "refs/tags/v${version}";
    hash = "sha256-BXKH3AlYMNbMREW5Qx72PrbuZdXlmVS+knWWu/y9PsA=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = [
    antlr4_8
    setuptools
  ];

  propagatedBuildInputs = [
    antlr4-python3-runtime''
    asciimatics
    click
    dacite
    decorator
    first
    future
    jsonpath-ng
    loguru
    overrides
    pillow
    ply
    pyfiglet
    pyperclip
    pyyaml
    six
    urwid''
    wcwidth
    yamale
  ];

  nativeCheckInputs = [
    pytestCheckHook
    parameterized
  ];

  # antlr4 issue prevents us from running the tests
  # https://github.com/antlr/antlr4/issues/4041
  doCheck = false;

  # pythonImportsCheck = [
  #   "pyfx"
  # ];

  meta = with lib; {
    description = "Module to view JSON in a TUI";
    mainProgram = "pyfx";
    homepage = "https://github.com/cielong/pyfx";
    changelog = "https://github.com/cielong/pyfx/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
