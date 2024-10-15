{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cliphist";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "cliphist";
    rev = "refs/tags/v${version}";
    hash = "sha256-AWLcHUwFphfUt6gCal+/OqfRmXs7I1m2Xcshe7kPFxQ=";
  };

  vendorHash = "sha256-gG8v3JFncadfCEUa7iR6Sw8nifFNTciDaeBszOlGntU=";

  postInstall = ''
    cp ${src}/contrib/* $out/bin/
  '';

  meta = with lib; {
    description = "Wayland clipboard manager";
    homepage = "https://github.com/sentriz/cliphist";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "cliphist";
  };
}
