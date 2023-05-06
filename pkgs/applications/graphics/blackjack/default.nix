{ rustPlatform, fetchFromGitHub, pkg-config, freetype, expat, fontconfig }:

rustPlatform.buildRustPackage {
  pname = "blackjack";
  version = "unstable-2023-03-26";

  src = fetchFromGitHub {
    owner = "setzer22";
    repo = "blackjack";
    rev = "cecfc27e8d3e23934f2a9901ea5be2de95b224a4";
    sha256 = "sha256-zzUbHFQoJYJQuzu83V0zb7p/1X5phVckI+Qtt8+DWq0=";
  };
  cargoLock = {
  lockFile = ./Cargo.lock; #cargoSha256 = "";
    outputHashes = {
      "egui-0.19.0" = "sha256-1ClcAmWIYt5nY3kFAQ/akWJs+w69RrjLqyDdk3AdaJ8=";
      "egui-gizmo-0.8.1" = "sha256-h0r6YJX7njSZplWxcOqunfNJhsAsgKwQTmcQn22FVEo=";
      "egui_node_graph-0.3.0" = "sha256-K9iX5uavxNsce+1vwjePFhISxCvyQQkjYhRS+Tyx/So=";
      "glsl-include-0.3.1" = "sha256-kG98vTfiloSolZqb/zRgtMj7GqEkxSP6svBCTb7t2sU=";
      "rend3-0.3.0" = "sha256-VEJPHAXpbWyxAv232YXuBAKyDAf+LjzrD7VOXe0LpeM=";
    };
  };
  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ freetype expat fontconfig ];
}
